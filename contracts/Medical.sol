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

    //UPDATE MEDICATION QUANTITY
    function UPDATE_MEDICINE_QUANTITY(uint _medicineId, uint _quantity) public onlyAdmin {
        require(_medicineId <= medicineCount, "Medicine does not exist");
        medicines[_medicineId].quantity = _quantity;

         ADD_NOTIFICATION(msg.sender, "Medicine quantity updated successfully", "Medicine");

        emit MEDICINE_QUANTITY(_medicineId, _quantity);
    }

    //UPDATE MEDICATION DISCOUNT
    function UPDATE_MEDICINE_DISCOUNT(uint _medicineId, uint _discount) public onlyAdmin {
        require(_medicineId <= medicineCount, "Medicine does not exist");
        medicines[_medicineId].discount = _discount;

         ADD_NOTIFICATION(msg.sender, "Medicine discount updated successfully", "Medicine");

        emit MEDICINE_DISCOUNT(_medicineId, _discount);
    }

    //UPDATE MEDICATION ACTIVE
   function UPDATE_MEDICINE_ACTIVE(uint _medicineId) public onlyAdmin {
        require(_medicineId <= medicineCount, "Medicine does not exist");
        medicines[_medicineId].active = !medicines[_medicineId].active;

         ADD_NOTIFICATION(msg.sender, "Medicine status updated successfully", "Medicine");

        emit MEDICINE_ACTIVE(_medicineId, medicines[_medicineId].active);
   }

    //--------------END OF MEDICINE------------------

    //--------------DOCTOR------------------

    //ADD DOCTOR
    function ADD_DOCTOR(string memory _IPFS_URL, address _address, string calldata _name,  string memory _type) public payable {
        require(msg.value == registrationDoctorFee, "Incorrect registration fee");
        require(!registeredDoctors[_address], "Doctor is already registered");
        
        doctorCount++;
        doctors[doctorCount] = Doctor(doctorCount, _IPFS_URL, _address, 0, 0, false);
        registeredDoctors[_address] = true;

        payable(admin).transfer(msg.value);

        //REGISTER
        CREATE_ACCOUNT(_name, _address, _type);

         ADD_NOTIFICATION(_address, "You have successfully completed the registration, now wating for approval", "Doctor");
         ADD_NOTIFICATION(admin, "New doctor is registor, now wating for approval", "Doctor");

        emit DOCTOR_REGISTERED(doctorCount, _IPFS_URL, _address);
    }

    // APPROVE DOCTOR STATUS
    function APPROVE_DOCTOR_STATUS(uint _doctorId) public onlyAdmin {
        require(_doctorId <= doctorCount, "Doctor does not exist");
        require(!doctors[_doctorId].isApproved, "Doctor is already approved");

        doctors[_doctorId].isApproved = !doctors[_doctorId].isApproved;

        ADD_NOTIFICATION(msg.sender, "You have approved Docotr registration", "Doctor");
        ADD_NOTIFICATION(doctors[_doctorId].accountAddress, "Your registration is approved", "Doctor");

        emit APPROVE_DOCTOR_STATUSD(_doctorId, doctors[_doctorId].isApproved);
    }

    // UPDATE BY DOCTOR
    function UPDATE_PATIENT_MEDICAL_HISTORY(uint _patientId, string memory _newMedicalHistory) public onlyDoctor {
            require(_patientId <= patientCount, "Patient does not exist");
            patients[_patientId].medicalHistory.push(_newMedicalHistory);

            ADD_NOTIFICATION(msg.sender, "You have successfully update, patient medical history", "Doctor");

            ADD_NOTIFICATION(patients[_patientId].accountAddress, "Your medical history updated by doctor", "Doctor");

            ADD_NOTIFICATION(msg.sender, "Patient medicial history is updated", "Doctor");
    }

    function COMPLETE_APPOINTMENT(uint _appointmentId) public onlyDoctor {
        require(_appointmentId <= appointmentCount, "Appointment does not exist");
        require(appointments[_appointmentId].doctorId == GET_DOCTOR_ID(msg.sender), "Only the assigned doctor can complete the appointment");

        appointments[_appointmentId].isOpen = false;
        doctors[GET_DOCTOR_ID(msg.sender)].successfulTreatmentCount++;

        ADD_NOTIFICATION(msg.sender, "You have successfully completed the appointment", "Doctor");

        ADD_NOTIFICATION(patients[appointments[_appointmentId].patientId].accountAddress, "Your Appointment is successfully completed", "Doctor");

        ADD_NOTIFICATION(admin, "Doctor completed appointment successfully", "Doctor");
    }

    function PRESCRIBE_MEDICINE(uint _medicineId, uint _patientId) public onlyDoctor {
        require(doctors[GET_DOCTOR_ID(msg.sender)].isApproved, "Doctor is not approved");

        prescriptionCount++;
        prescriptions[prescriptionCount] = Prescription(prescriptionCount, _medicineId, _patientId, GET_DOCTOR_ID(msg.sender), block.timestamp);
        emit MEDICINE_PRESCRIBED(prescriptionCount, _medicineId, _patientId, GET_DOCTOR_ID(msg.sender), block.timestamp);

        ADD_NOTIFICATION(msg.sender, "You have successfully prescribed medicine", "Doctor");

        ADD_NOTIFICATION(patients[_patientId].accountAddress, "Doctor prescribed you medicine", "Doctor");

        ADD_NOTIFICATION(admin, "Doctor prescribed medicine successfully", "Doctor");
    }

    //--------------END OF DOCTOR------------------

    //--------------PATIENT------------------

    /// ADD PATIENTS
    function ADD_PATIENTS(string memory _IPFS_URL, string[] memory _medicalHistory, address _accountAddress, uint[] memory _boughtMedicines, string calldata _name, address _doctorAddress, string calldata _doctorName, string memory _type) public payable {
            require(msg.value == registrationPatientFee, "Incorrect registration fee");
            require(!registeredPatients[_accountAddress], "Patient is already registered");

            patientCount++;
            patients[patientCount] = Patient(patientCount, _IPFS_URL, _medicalHistory, _accountAddress, _boughtMedicines);
            registeredPatients[_accountAddress] = true;

            payable(admin).transfer(msg.value);

            //REGISTER
            CREATE_ACCOUNT(_name, _accountAddress, _type);

             //CHAT FRIEND
            ADD_FRIEND(_doctorAddress, _doctorName, _accountAddress);

            ADD_NOTIFICATION(_accountAddress, "You have successfully completed registration", "Patient");

            ADD_NOTIFICATION(admin, "New Patient is registor successfully", "Patient");

            emit PATIENT_ADDED(patientCount, _IPFS_URL, _medicalHistory);
    }

    /// BOOK_APPOINTMENT
    function BOOK_APPOINTMENT(uint _patientId, uint _doctorId, string memory _from,string memory _to,string memory _appointmentDate,string memory _condition, string memory _message, address _doctorAddress, string calldata _name) public payable {
            require(_patientId <= patientCount, "Patient does not exist");
            require(_doctorId <= doctorCount, "Doctor does not exist");
            require(doctors[_doctorId].isApproved, "Doctor is not approved");
            require(patients[_patientId].accountAddress == msg.sender, "Only the patient can book their appointment");
            require(msg.value == appointmentFee, "Incorrect appointment fee");

            uint adminShare = msg.value / 10;
            uint doctorShare = msg.value - adminShare;

            appointmentCount++;
            appointments[appointmentCount] = Appointment(appointmentCount, _patientId, _doctorId, block.timestamp, _from,_to, _appointmentDate, _condition, _message, true);

            doctors[_doctorId].appointmentCount++;
            
            payable(admin).transfer(adminShare);
            payable(doctors[_doctorId].accountAddress).transfer(doctorShare);

            //CHAT FRIEND
            ADD_FRIEND(_doctorAddress, _name, msg.sender);

            ADD_NOTIFICATION(_doctorAddress, "You have a new appointment", "Patient");

            ADD_NOTIFICATION(msg.sender, "You have successfully booked an appointment", "Patient");

            ADD_NOTIFICATION(admin, "New appointment booked", "Patient");

            emit APPOINTMENT_BOOKED(appointmentCount, _patientId, _doctorId, block.timestamp);
    }

    function BUY_MEDICINE(uint _patientId, uint _medicineId, uint _quantity) public payable {
        require(_patientId <= patientCount, "Patient does not exist");
        require(_medicineId <= medicineCount, "Medicine does not exist");
        require(patients[_patientId].accountAddress == msg.sender, "Only the patient can buy their medicine");
        require(medicines[_medicineId].active, "Medicine is not active");
        require(medicines[_medicineId].quantity >= _quantity, "Not enough medicine in stock");

        uint totalPrice = medicines[_medicineId].price * _quantity;

        medicines[_medicineId].quantity -= _quantity;

        patients[_patientId].boughtMedicines.push(_medicineId);

        patientOrders[_patientId].push(Order({
            medicineId: _medicineId,
            price: medicines[_medicineId].price,
            payAmount: totalPrice,
            quantity: _quantity,
            patientId: _patientId,
            date: block.timestamp
        }));

         ADD_NOTIFICATION(msg.sender, "You have successfully bought medicine", "Patient");

        ADD_NOTIFICATION(admin, "Transaction completed, madicine bought successfully", "Patient");

        emit MEDICINE_BOUGHT(_patientId, _medicineId);
    }

    //--------------END OF PATIENT------------------


}