// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./libraries/EthConverter.sol";

error serverError();
contract FundMe {
    uint256 constant MINIMUM_USD = 25 * 1e18;
    address immutable i_owner;
    address immutable i_network;
    FunderDetail[] public funderDetails;

    struct FunderDetail {
        address funder_address;
        uint256 fund;
        string unit;
        string status;
    }

    constructor(address network_address) {
        i_owner = msg.sender;
        i_network = network_address;
    }

    function fundMe() public payable {
        // validation
        require(EthConverter.convertEther(i_network, msg.value) >= MINIMUM_USD, "Not enough funds!");
        FunderDetail memory funder = FunderDetail({
            funder_address: msg.sender,
            fund: msg.value,
            unit: "wei",
            status: "PAID"
        });

        funderDetails.push(funder);
    }

    function withdraw() public onlyOwner {
        for (uint256 i = 0; i < funderDetails.length; i++) {
            funderDetails[i].fund = 0;
            funderDetails[i].status = "WITHDRAWN";
        }

        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "call failed!");
    }

    receive() external payable {
        fundMe();
    }

    fallback() external payable {
        fundMe();
    }

    modifier onlyOwner {
        if (msg.sender != i_owner) {
            revert serverError();
        }
        _;
    }

}