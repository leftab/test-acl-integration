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

    function increment(uint256 step) auth(INCREMENT_ROLE) external auth(DATASTORE_MANAGER_ROLE)  {
        value = value.add(step);
        datastoreACL.test();
    }

    function decrement(uint256 step) auth(DECREMENT_ROLE) external {
        value = value.sub(step);
    }


    using PermissionLibrary for PermissionLibrary.PermissionData;
    using FileLibrary for FileLibrary.FileList;
    using GroupLibrary for GroupLibrary.GroupData;

    bytes32 constant public DATASTORE_MANAGER_ROLE = keccak256("DATASTORE_MANAGER_ROLE");
    bytes32 constant public FILE_OWNER_ROLE = keccak256("FILE_OWNER_ROLE");


    event FileRename(address indexed entity);
    event FileContentUpdate(address indexed entity);
    event NewFile(address indexed entity);
    event NewWritePermission(address indexed entity);
    event NewReadPermission(address indexed entity);
    event NewEntityPermissions(address indexed entity);
    event NewGroupPermissions(address indexed entity);
    event NewPermissions(address indexed entity);
    event DeleteFile(address indexed entity);
    event SettingsChanged(address indexed entity);
    event GroupChange(address indexed entity);
    event EntityPermissionsRemoved(address indexed entity);
    event GroupPermissionsRemoved(address indexed entity);

    /**
     * Datastore settings
     */
    enum StorageProvider { None, Ipfs, Filecoin, Swarm }
    enum EncryptionType { None, Aes }

    struct Settings {
        StorageProvider storageProvider;
        EncryptionType encryption;

        string ipfsHost;
        uint16 ipfsPort;
        string ipfsProtocol;
    }

    /** 
     *  TODO: Use IpfsSettings inside Settings when aragon supports nested structs
     */
    struct IpfsSettings {
        string host;
        uint16 port;
        string protocol;        
    }
    
    FileLibrary.FileList private fileList;


    PermissionLibrary.PermissionData private permissions;
    GroupLibrary.GroupData private groups;
    Settings public settings;

    ACL private acl;
    DatastoreACL private datastoreACL;

    function initialize(address _datastoreACL) onlyInit public {
        initialized();

        acl = ACL(kernel().acl());
        datastoreACL = DatastoreACL(_datastoreACL);  

        permissions.init(datastoreACL);
        groups.init(datastoreACL);              
    }


}
