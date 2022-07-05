import 'dart:convert';
import 'dart:ffi';

import 'package:e_voting_project_final/Pages/resources.dart';
import 'package:e_voting_project_final/services/snackBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

import 'package:web_socket_channel/io.dart';

class ContractLinking extends ChangeNotifier {
  final String _rpcUrl = "http://192.168.43.33:7545";
  final String _wsUrl = "ws://192.168.43.33:7545/";

  //admin private key
  final String _privateKey = "1b2a7f91a673f48d3a92a18b7feffdfc1fe2781104a3250335b1907f810c0570";

  Web3Client _client;
  bool isLoading = true;
  String state;

  String _abiCode;
  EthereumAddress _contractAddress;

  DeployedContract _contract;
  String winnerName;
  String winnerGainVotes;
  String public;
  String private;
  String amount;
  String electionName = "";
  String electionState = "";
  String candidateCount;
  String VoterCount;
  var finalcount;
  var electionDetail = new Map();
  var candidatesData = new Map();
  var candidateVoteData = new Map();
  var candidateResultData = new Map();
  var electionData = new Map();
  var VoterData = new Map();
  var VoterRec = new Map();
  var SingleVoterRec = new Map();

  Credentials _credentials;
  Credentials _credentials2;
  ContractFunction _checkState;
  ContractFunction _addCandidate;
  ContractFunction _addVoter;
  ContractFunction _startElection;
  ContractFunction _displayCandidate;
  ContractFunction _showWinner;
  ContractFunction _vote;
  ContractFunction _endElection;
  ContractFunction _showResults;
  ContractFunction _getVoter;
  ContractFunction _voterProfile;
  ContractFunction _countCandidate;
  ContractFunction _voterCount;
  ContractFunction _getElectiondetails;

  ContractLinking() {
    initialSetup();
  }

  String addres;

  initialSetup() async {
    // establish a connection to the ethereum rpc node. The socketConnector
    // property allows more efficient event streams over websocket instead of
    // http-polls. However, the socketConnector property is experimental.
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });

    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    // Reading the contract abi
    String abiStringFile =
    await rootBundle.loadString("src/artifacts/Election.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
  }

  Future<EthereumAddress> getCredentials() async {
    _credentials = await _client.credentialsFromPrivateKey(_privateKey);
    return _credentials.extractAddress();
  }

  Future<void> getDeployedContract() async {
    // Telling Web3dart where our contract is declared.
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "Election"), _contractAddress);

    // Extracting the functions, declared in contract.
    _startElection = _contract.function("startElection");
    _addVoter = _contract.function("addVoter");
    _checkState = _contract.function("checkState");
    _addCandidate = _contract.function("addCandidate");
    _addVoter = _contract.function("addVoter");
    _startElection = _contract.function("startElection");
    _displayCandidate = _contract.function("displayCandidate");
    _showWinner = _contract.function("showWinner");
    _vote = _contract.function("vote");
    _endElection = _contract.function("endElection");
    _showResults = _contract.function("showResults");
    _getVoter = _contract.function("getVoter");
    _voterProfile = _contract.function("voterProfile");
    _countCandidate = _contract.function("candidate_count");
    _voterCount = _contract.function("voter_count");
    _getElectiondetails = _contract.function("getElectiondetails");
    _vote = _contract.function("vote");
    //EthereumAddress eth = await _credentials.extractAddress();
    checkState();
    countCandidate();
    countVoter();
    showResults();
    getElectiondetails();
    displayCandidate();
    getVoter("0xA3385511a42A84986Cd2A399Aee7060fBa979058");
    voterProfile();
    showWinner();
    return _contract;
  }

  countCandidate() async {
    var count = await _client
        .call(contract: _contract, function: _countCandidate, params: []);

    var count1 = count.elementAt(0);
    notifyListeners();
    candidateCount = count1.toString();
    finalcount = count1;

    return count1;
  }

  countVoter() async {
    var count = await _client
        .call(contract: _contract, function: _voterCount, params: []);

    var count1 = count.elementAt(0);
    notifyListeners();
    VoterCount = count1.toString();
    finalcount = count1;

    return count1;
  }

  addCandidate(List list, String owner) async {
    try {
      for (var i in list) {
        var added = await _client.sendTransaction(
            _credentials,
            Transaction.callContract(
                contract: _contract,
                function: _addCandidate,
                parameters: [
                  i.getName().split("/")[0].trim(),
                  i.getName().split("/")[1].trim(),
                  EthereumAddress.fromHex(owner)],
                maxGas: 6721974));
        Fluttertoast.showToast(msg: "Candidate is added at\n tx- $added!",
            backgroundColor: kmainColor,
            textColor: Colors.white);
        notifyListeners();
      }
    }
    catch (err) {
      Fluttertoast.showToast(
          msg: "Transaction Failed!\nOnly Admin Can Add the Candidate, Kindly check your Address!",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          timeInSecForIosWeb: 2);
    }
  }

  displayCandidate() async {
    try {
      var count = await _client
          .call(contract: _contract, function: _countCandidate, params: []);
      var count1 = count.elementAt(0);
      finalcount = count1;
      List candidate = [];
      List candidate1 = [];
      for (var i = 1; i <= finalcount.toInt(); i++) {
        var can = await _client.call(
            contract: _contract,
            function: _displayCandidate,
            params: [BigInt.from(i.toInt())]);
        candidate.add(can[1]);
        candidate1.add(can.elementAt(0).toString() + "/" + can[1] + "/" +
            can[2].toString());
      }
      candidatesData["CR of Class"] = candidate;
      candidateVoteData["CR of Class"] = candidate1;
      notifyListeners();

      isLoading = false;
    } catch (Exception) {
      Snackbar(content: "There is an issue to display candiates!",
          color: Colors.red);
    }
  }

  getElectiondetails() async {
    try {
      var can = await _client
          .call(contract: _contract, function: _getElectiondetails, params: []);
      electionName = can[0];
      electionState = can[1];
      notifyListeners();
      return can;
    } catch (Exception) {
      print(Exception);
    }
  }

  startElection(String name, String owner) async {
    try {
      var startElection = await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
              contract: _contract,
              function: _startElection,
              parameters: [name, EthereumAddress.fromHex(owner)],
              maxGas: 6721974));
      Fluttertoast.showToast(msg: "Election Started!",
          backgroundColor: kmainColor,
          textColor: Colors.white);
      notifyListeners();
      getElectiondetails();
      return startElection;
    } catch (err) {
      Fluttertoast.showToast(
          msg: "Only Admin Can Start the Election, Kindly check your Address!!",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          timeInSecForIosWeb: 2);
    }

    return startElection;
  }

  endElection(String owner) async {
    try {
      var endElection = await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
              contract: _contract,
              function: _endElection,
              parameters: [EthereumAddress.fromHex(owner)],
              maxGas: 6721974));

      notifyListeners();
      Fluttertoast.showToast(msg: "Election is Ended!",
          backgroundColor: kmainColor,
          textColor: Colors.white);

      getElectiondetails();
    } catch (Exception) {
      Fluttertoast.showToast(
          msg: "Only Admin Can End the Election!, Kindly check your Address!",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          timeInSecForIosWeb: 2);
    }
  }

  checkState() async {
    var state1 = await _client
        .call(contract: _contract, function: _checkState, params: []);

    isLoading = false;
    state = state1[0];
    if (state == "CONCLUDED" || state == "CREATED") {
      showWinner();
    }
    notifyListeners();
  }

  addVoter(List list, String voter, String owner) async {
    for (var i in list) {
      try {
        var addVoter = await _client.sendTransaction(
            _credentials,
            Transaction.callContract(
                contract: _contract,
                function: _addVoter,
                parameters: [
                  EthereumAddress.fromHex(i.getID().toString().trim()),
                  i.getName().split("/")[0].trim(),
                  i.getName().split("/")[1].trim(),
                  EthereumAddress.fromHex(owner)
                ],
                maxGas: 6721974));
        Fluttertoast.showToast(
            msg: i.getName().split("/")[0].trim() + " is Authorized!",
            backgroundColor: kmainColor,
            textColor: Colors.white);
        notifyListeners();
      } catch (err) {
        if (err.toString().split("revert")[1].trim().toString().split(".")[0] ==
            "Voter has already been registered") {
          Fluttertoast.showToast(msg: i.getName().split("/")[0].trim() +
              " has already been registered!",
              backgroundColor: Colors.red,
              textColor: Colors.white,
              timeInSecForIosWeb: 2);
        }
        else {
          Fluttertoast.showToast(
              msg: "Only Admin Can Authorized the Voter!, Kindly check your Address!",
              backgroundColor: Colors.red,
              textColor: Colors.white,
              timeInSecForIosWeb: 2);
        }
      }
    }
  }

  voterProfile() async {
    try {
      for (var j in VoterData.entries) {
        List candidate1 = [];
        for (var i in j.value) {
          String address = i.toString().split("/")[1].toString().trim();
          var can = await _client.call(contract: _contract,
              function: _voterProfile,
              params: [EthereumAddress.fromHex(address)]);
          candidate1.add(
              can.elementAt(0).toString() + "/" + can[1].toString() + "/" +
                  can[2].toString() + "/" + can[5].toString());
        }
        VoterRec["VoterProfile"] = candidate1;
      }
    } catch (Exception) {
      Fluttertoast.showToast(
          msg: "Only Admin Can Authorized the Voter!, Kindly check your Address!",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          timeInSecForIosWeb: 2);
    }
  }

  getVoter(String owner) async {
    try {
      var count = await _client
          .call(contract: _contract, function: _voterCount, params: []);

      var count1 = count.elementAt(0);
      var num = count1;

      List candidate = [];
      List candidate1 = [];
      for (var i = 1; i <= num.toInt(); i++) {
        var can = await _client.call(
            contract: _contract,
            function: _getVoter,
            params: [BigInt.from(i.toInt()), EthereumAddress.fromHex(owner)]);
        candidate.add(can[1]);

        candidate1.add(
            can.elementAt(0).toString() + "/" + can[1].toString() + "/" +
                can.elementAt(2).toString());
      }
      VoterData["Voters"] = candidate1;
      return VoterData;
    } catch (Exception) {
      Snackbar(
          color: Colors.red, content: "There is an issue to get Voter details");
    }
  }

  Future<bool> getvoterProfile(String address) async {
    bool hasVoted = false;
    try {
      List candidate1 = [];
      var can = await _client.call(contract: _contract,
          function: _voterProfile,
          params: [EthereumAddress.fromHex(address)]);
      candidate1.add(
          can.elementAt(0).toString() + "/" + can[1].toString() + "/" +
              can[2].toString() + "/" + can[5].toString());
      SingleVoterRec["Single Voter"] = candidate1;
      showResults();
      notifyListeners();
      hasVoted = true;
    } catch (Exception) {
      Fluttertoast.showToast(
          msg: "Only Admin Can Authorized the Voter!, Kindly check your Address!",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          timeInSecForIosWeb: 2);
    }
    return hasVoted;
  }

  Future<bool> Vote(String id, String owner) async {
    bool hasVoted = false;
    try {
      var ID = int.parse(id);

      var vote = await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
              contract: _contract,
              function: _vote,
              parameters: [BigInt.from(ID), EthereumAddress.fromHex(owner)],
              maxGas: 6721974));
      Fluttertoast.showToast(msg: "Your Vote is recorded!",
          backgroundColor: kmainColor,
          textColor: Colors.white);
      hasVoted = true;
      getvoterProfile(owner);
      notifyListeners();
    }
    catch (err) {
      if (err.toString().split("revert")[1].trim().toString().split(".")[0] ==
          "Voter has already voted") {
        Fluttertoast.showToast(msg: "You have already Cast Your Vote!",
            backgroundColor: Colors.red,
            textColor: Colors.white,
            timeInSecForIosWeb: 2);
      }
      else {
        Fluttertoast.showToast(msg: "You are not Authorized for this Election!",
            backgroundColor: Colors.red,
            textColor: Colors.white,
            timeInSecForIosWeb: 2);
      }
    }
    return hasVoted;
  }

  showWinner() async {
    try {
      var can = await _client
          .call(contract: _contract, function: _showWinner, params: []);
      winnerName = can[0].toString();
      winnerGainVotes = can.elementAt(2).toString();

      notifyListeners();
    } catch (Exception) {
      Snackbar(color: Colors.red, content: "There is an issue to Show Winner",);
    }
  }

  showResults() async {
    try {
      var count = await _client
          .call(contract: _contract, function: _countCandidate, params: []);
      var count1 = count.elementAt(0);
      finalcount = count1;
      List candidate1 = [];
      for (var i = 1; i <= finalcount.toInt(); i++) {
        var can = await _client.call(
            contract: _contract,
            function: _showResults,
            params: [BigInt.from(i)]);

        candidate1.add(
            can.elementAt(0).toString() +
                "/" +
                can[1].toString() +
                "/" +
                can[2].toString() +
                "/" +
                can.elementAt(3).toString()
        );
      }
      candidateResultData["CR of Class"] = candidate1;

      notifyListeners();
    }
    catch (Exception) {
      Snackbar(color: Colors.red, content: "There is an issue to Show Result",);
    }
  }
}