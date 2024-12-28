// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Healthcare {
    struct Medicine {
        uint id;
        string IPFS_URL;
        uint price;
        uint quantity;
        uint discount;
        string currentLocation;
        bool active;
    }
    
    struct Doctor {
        uint id;
        string IPFS_URL;  
        address accountAddress;
        uint appointmentCount;
        uint successfulTreatmentCount;
        bool isApproved;
    }

    struct Patient {
        uint id;
        string IPFS_URL; 
        string[] medicalHistory; 
        address accountAddress;
        uint[] boughtMedicines;
    }

    struct Prescription {
        uint id;
        uint medicineId;
        uint patientId;
        uint doctorId;
        uint date;
    }
    

    struct Appointment {
        uint id;
        uint patientId;
        uint doctorId;
        uint date;
        string from;
        string to;
        string appointmentDate;
        string condition;
        string message;
        bool isOpen;
    }

    struct User {
        string name;
        string userType;
        friend[] friendList;
    }

    struct friend{
        address pubkey;
        string name;
    }

    struct message{
        address sender;
        uint256 timestamp;
        string msg;
    }

    struct AllUserStruck{
        string name;
        address accountAddress;
    }

    struct Order {
        uint medicineId;
        uint price;
        uint payAmount;
        uint quantity;
        uint patientId;
        uint date;
    }

    struct Notification {
        uint id;
        address userAddress;
        string message;
        uint timestamp;
        string categoryType;
    }

    AllUserStruck[] getAllUsers;

    mapping(address => User) userList;
    mapping(bytes32 => message[]) allMessages;
    
    mapping(address => Notification[]) private notifications;
    mapping(uint => Order[]) public patientOrders;
    mapping(uint => Medicine) public medicines;
    mapping(uint => Doctor) public doctors;
    mapping(uint => Patient) public patients;
    mapping(uint => Prescription) public prescriptions;
    mapping(uint => Appointment) public appointments;
    mapping(address => bool) public registeredDoctors;
    mapping(address => bool) public registeredPatients;

    uint public medicineCount;
    uint public doctorCount;
    uint public patientCount;
    uint public prescriptionCount;
    uint public appointmentCount;

    address payable public admin;
    uint public registrationDoctorFee = 0.0025 ether;
    uint public registrationPatientFee = 0.00025 ether;
    uint public appointmentFee = 0.0025 ether;
  

   //MEDICATION
    event MEDICINE_ADDED(uint id, string url, string location);
    event MEDICINE_LOCATION(uint id, string newLocation);
    event MEDICINE_PRICE(uint id, uint price);
    event MEDICINE_DISCOUNT(uint id, uint discount);
    event MEDICINE_QUANTITY(uint id, uint quantity);
    event MEDICINE_ACTIVE(uint id, bool active);    
    event MEDICINE_BOUGHT(uint patientId, uint medicineId);
    //END MEDICATION

    //DOCTOR
     event DOCTOR_REGISTERED(uint id, string IPFS_URL, address accountAddress);
     event APPROVE_DOCTOR_STATUSD(uint id, bool isApproved);
    //END DOCTOR

   //PATIENTS
    event PATIENT_ADDED(uint id, string _IPFS_URL, string[] medicalHistory);
    event NOTIFICATiON_SENT(address indexed user, string message, uint timestamp);
   //END PATIENTS
   
    //PRESCRIBED
    event MEDICINE_PRESCRIBED(uint id, uint medicineId, uint patientId, uint doctorId, uint date);
    event APPOINTMENT_BOOKED(uint id, uint patientId, uint doctorId, uint date);
    //END PRESCRIBED

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    modifier onlyDoctor() {
        require(registeredDoctors[msg.sender], "Only registered doctors can perform this action");
        _;
    }

    constructor() {
        admin = payable(msg.sender);
    }

    //NOTIFICATIOn
    function ADD_NOTIFICATION(address _userAddress, string memory _message, string memory _type) internal {
        Notification memory newNotification = Notification({
            id: notifications[_userAddress].length,
            userAddress: _userAddress,
            message: _message,
            timestamp: block.timestamp,
            categoryType: _type
        });

        notifications[_userAddress].push(newNotification);
        emit NOTIFICATiON_SENT(_userAddress, _message, block.timestamp);
    }

    function GET_NOTIFICATIONS(address _userAddress) external view returns (Notification[] memory) {
        return notifications[_userAddress];
    }

    //--------------MEDICINE------------------

    ///ADD MEDICATION
    function ADD_MEDICINE( string memory _IPFS_URL,  uint _price, uint _quantity,uint _discount, string memory _currentLocation) public onlyAdmin {
        medicineCount++;
        medicines[medicineCount] = Medicine(medicineCount, _IPFS_URL, _price, _quantity, _discount, _currentLocation, true);

        ADD_NOTIFICATION(msg.sender, "New Medicine added to marketplace successfully!", "Medicine");

        emit MEDICINE_ADDED(medicineCount, _IPFS_URL, _currentLocation);
    }

    //UPDATE MEDICATION LOCATION
    function UPDATE_MEDICINE_LOCATION(uint _medicineId, string memory _newLocation) public onlyAdmin {
        require(_medicineId <= medicineCount, "Medicine does not exist");
        medicines[_medicineId].currentLocation = _newLocation;

        ADD_NOTIFICATION(msg.sender, "Medicine location updated successfully", "Medicine");

        emit MEDICINE_LOCATION(_medicineId, _newLocation);
    }

    //UPDATE MEDICATION PRICE
    function UPDATE_MEDICINE_PRICE(uint _medicineId, uint _price) public onlyAdmin {
        require(_medicineId <= medicineCount, "Medicine does not exist");
        medicines[_medicineId].price = _price;

         ADD_NOTIFICATION(msg.sender, "Medicine price updated successfully", "Medicine");

        emit MEDICINE_PRICE(_medicineId, _price);
    }

}