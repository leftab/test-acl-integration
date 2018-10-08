pragma solidity ^0.4.24;

import "@aragon/os/contracts/apps/AragonApp.sol";
import "@aragon/os/contracts/lib/math/SafeMath.sol";

import "./DatastoreACL.sol";
import "./libraries/PermissionLibrary.sol";
import "./libraries/GroupLibrary.sol";
import "./libraries/FileLibrary.sol";

contract CounterApp is AragonApp {
    using SafeMath for uint;

    /// State
    uint256 public value;



    /// ACL
    bytes32 constant public INCREMENT_ROLE = keccak256("INCREMENT_ROLE");
    bytes32 constant public DECREMENT_ROLE = keccak256("DECREMENT_ROLE");

    function increment(uint256 step) auth(INCREMENT_ROLE) external {
        value = value.add(step);
    }

    function decrement(uint256 step) auth(DECREMENT_ROLE) external {
        value = value.sub(step);
    }


    using PermissionLibrary for PermissionLibrary.PermissionData;
    using FileLibrary for FileLibrary.FileList;
    using GroupLibrary for GroupLibrary.GroupData;

    bytes32 constant public DATASTORE_MANAGER_ROLE = keccak256("DATASTORE_MANAGER_ROLE");
    bytes32 constant public FILE_OWNER_ROLE = keccak256("FILE_OWNER_ROLE");


    ACL private acl;
    DatastoreACL private datastoreACL;

    function initialize(address _datastoreACL) onlyInit public {
        initialized();

        acl = ACL(kernel().acl());
        datastoreACL = DatastoreACL(_datastoreACL);        
    }


}
