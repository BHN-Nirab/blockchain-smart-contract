//SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BasicLevel {

    address guessingGameTokenAddress;
    bytes32 secretNumber;
    uint256[] possibleHints;
    uint256 maximumNumberOfTries;
    uint256 winAmount;
    mapping (address => bool) addressAndWinstatusHashMap;
    mapping (address => uint256) currentTryCount; 

    constructor (address _guessingGameTokenAddress, uint256 _secretNumber, uint256[] memory _possibleHints, uint256 _maximumNumberOfTries, uint256 _winAmount) 
    {
        guessingGameTokenAddress = _guessingGameTokenAddress;
        secretNumber = keccak256(abi.encodePacked(_secretNumber));
        possibleHints = _possibleHints;
        maximumNumberOfTries = _maximumNumberOfTries;
        winAmount = _winAmount;
        addressAndWinstatusHashMap[msg.sender] = true;
    }

    function GuessNow(uint256 _number) external payable {
        require(addressAndWinstatusHashMap[msg.sender] == true, "You don't have permission to play the game");
        currentTryCount[msg.sender]++;
        
        if(currentTryCount[msg.sender] <= maximumNumberOfTries && keccak256(abi.encodePacked(_number)) == secretNumber) {
            addressAndWinstatusHashMap[msg.sender] = true;
            IERC20(guessingGameTokenAddress).transfer(msg.sender, winAmount);
        }
    }

    function GetHints() external view returns (uint256[] memory) {
        return possibleHints;
    }

}
