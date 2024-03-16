// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "node_modules/@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol"

library EthConverter {
    function convertEather(address networkAddress, uint256 ethAmount) public pure returns(uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(networkAddress);
        (,int256 price,,,) = priceFeed.latestRoundData();

        uint256 ethPrice = uint256(price * 1e10);
        uint256 ethAmountInUSD = (ethPrice * ethAmount) / 1e18;

        return ethAmountInUSD;
    }
}