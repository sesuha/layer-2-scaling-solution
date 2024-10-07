// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Layer2ScalingSolution {
    mapping(address => uint256) public balances;
    mapping(address => uint256) public layer2Balances;

    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);
    event TransferToLayer2(address indexed user, uint256 amount);
    event TransferFromLayer2(address indexed user, uint256 amount);

    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
        emit Withdraw(msg.sender, _amount);
    }

    function transferToLayer2(uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
        layer2Balances[msg.sender] += _amount;
        emit TransferToLayer2(msg.sender, _amount);
    }

    function transferFromLayer2(uint256 _amount) public {
        require(layer2Balances[msg.sender] >= _amount, "Insufficient Layer 2 balance");
        layer2Balances[msg.sender] -= _amount;
        balances[msg.sender] += _amount;
        emit TransferFromLayer2(msg.sender, _amount);
    }

    function getBalance(address _user) public view returns (uint256) {
        return balances[_user];
    }

    function getLayer2Balance(address _user) public view returns (uint256) {
        return layer2Balances[_user];
    }
}
