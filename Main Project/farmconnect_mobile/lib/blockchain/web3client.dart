import 'dart:convert';
import 'dart:io';

import 'package:farmconnect/blockchain/user_datastructure.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class UserServices extends ChangeNotifier {
  List<User> users = [];
  final String _rpcUrl =
  Platform.isAndroid ? 'http://10.0.2.2:7545' : 'http://127.0.0.1:7545';
  final String _wsUrl =
  Platform.isAndroid ? 'http://10.0.2.2:7545' : 'ws://127.0.0.1:7545';
  bool isLoading = true;

  final String _privatekey =
      '0xea0bc79a03c2b07a8c9a3bfce6abd0e2b5d10c79c1b22c43c9e59fadfc45399c';
  late Web3Client _web3Client;

  UserServices() {
    init();
  }

  Future<void> init() async {
    _web3Client = Web3Client(
      _rpcUrl,
      http.Client(),
      socketConnector: () {
        return IOWebSocketChannel.connect(_wsUrl).cast<String>();
      },
    );
    await getABI();
    await getCredentials();
    await getDeployedContract();
  }

  late ContractAbi _abiCode;
  late EthereumAddress _contractAddress;
  Future<void> getABI() async {
    String abiFile = await rootBundle
        .loadString('build/contracts/UserDetailsContract.json');
    var jsonABI = jsonDecode(abiFile);
    _abiCode = ContractAbi.fromJson(
        jsonEncode(jsonABI['abi']), 'UserDetailsContract');
    _contractAddress = EthereumAddress.fromHex(
        jsonABI["networks"]["5777"]["address"]);
  }

  late EthPrivateKey _credentials;
  Future<void> getCredentials() async {
    _credentials = EthPrivateKey.fromHex(_privatekey);
  }

  late DeployedContract _deployedContract;
  late ContractFunction _createUserDetails;

  Future<void> getDeployedContract() async {
    _deployedContract = DeployedContract(_abiCode, _contractAddress);
    _createUserDetails = _deployedContract.function('createUserDetails');
    await fetchUsers();
  }

  Future<void> fetchUsers() async {
    List userCountList = await _web3Client.call(
      contract: _deployedContract,
      function: _deployedContract.function('userCount'),
      params: [],
    );

    int userCount = userCountList[0].toInt();
    users.clear();
    for (var i = 0; i < userCount; i++) {
      var user = await _web3Client.call(
        contract: _deployedContract,
        function: _deployedContract.function('userDetails'),
        params: [BigInt.from(i)],
      );

      users.add(
        User(
          id: (user[0] as BigInt).toInt(),
          fuid: user[1],
          name: user[2],
          farmname: user[3],
          email: user[4],
          phone: user[5],
          aadhar: user[6],
          address: user[7],
        ),
      );
    }
    isLoading = false;

    notifyListeners();
  }

  Future<void> addUser({
    required String fuid,
    required String name,
    required String farmname,
    required String email,
    required String phone,
    required String aadhar,
    required String address,
  }) async {
    await _web3Client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _deployedContract,
        function: _createUserDetails,
        parameters: [
          fuid,
          name,
          farmname,
          email,
          phone,
          aadhar,
          address,
        ],
      ),
      chainId: 1337,
    );
    isLoading = true;
    fetchUsers();
  }
}
