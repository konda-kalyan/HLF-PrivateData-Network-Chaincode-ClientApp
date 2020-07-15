package com.kalyan.hyperledger.clientapp.restcontroller;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.net.MalformedURLException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.TimeoutException;

import org.hyperledger.fabric.gateway.Contract;
import org.hyperledger.fabric.gateway.ContractException;
import org.hyperledger.fabric.gateway.Gateway;
import org.hyperledger.fabric.gateway.Network;
import org.hyperledger.fabric.gateway.Wallet;
import org.hyperledger.fabric.gateway.Wallet.Identity;
import org.hyperledger.fabric.gateway.impl.WalletIdentity;
import org.hyperledger.fabric.sdk.Enrollment;
import org.hyperledger.fabric.sdk.NetworkConfig;
import org.hyperledger.fabric.sdk.NetworkConfig.OrgInfo;
import org.hyperledger.fabric.sdk.exception.CryptoException;
import org.hyperledger.fabric.sdk.exception.InvalidArgumentException;
import org.hyperledger.fabric.sdk.exception.NetworkConfigurationException;
import org.hyperledger.fabric.sdk.security.CryptoSuite;
import org.hyperledger.fabric.shim.ChaincodeException;
import org.hyperledger.fabric_ca.sdk.HFCAClient;
import org.hyperledger.fabric_ca.sdk.RegistrationRequest;
import org.hyperledger.fabric_ca.sdk.exception.EnrollmentException;
import org.hyperledger.fabric_ca.sdk.exception.RegistrationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.kalyan.hyperledger.clientapp.model.Employee;
import com.kalyan.hyperledger.clientapp.model.UserContext;

@RestController("/")
public class PrivateDataRestController {

	public PrivateDataRestController() {
		// ***** Do all initial setup to invoke/interact with chaincodes/contracts
		setup();
	}

	@GetMapping("test")
	public String test() {
		return "test string";
	}
			
	@PostMapping("employee")
	public ResponseEntity<Employee> addEmployee(@RequestBody Employee employee)
			throws JsonProcessingException {

		ObjectMapper mapper = new ObjectMapper();
		String requestString = mapper.writeValueAsString(employee);
		byte[] ccResult = null;
		
		try {
//			ccResult = contract.submitTransaction("addEmployee", employee.getEmpID(), requestString); // **** Chaincode call
			ccResult = contract.submitTransaction("addEmployee", employee.getEmpID(), employee.getEmpName(), employee.getDepartment(), Double.toString(employee.getSalary()), employee.getLocation()); // **** Chaincode call
		} catch (ContractException | TimeoutException | InterruptedException e1) {
			e1.printStackTrace();
			throw new ChaincodeException(e1.getMessage());
		}

		String ccResultString = new String(ccResult, StandardCharsets.UTF_8);
		System.out.println("Kalyan: addEmployee: response string: " + ccResultString);
		ObjectMapper mapper1 = new ObjectMapper();
		Employee emp = mapper1.readValue(ccResultString, Employee.class);
		return new ResponseEntity<>(emp, HttpStatus.OK);
	} // add employee REST ends
	
	@GetMapping("employee/{id}")
	public ResponseEntity<Employee> getEmployee(@PathVariable("id") String empId)
			throws JsonProcessingException {

		byte[] ccResult = null;
		
		try {
			ccResult = contract.submitTransaction("queryEmployee", empId); // **** Chaincode call
			
		} catch (ContractException | TimeoutException | InterruptedException e1) {
			e1.printStackTrace();
			throw new ChaincodeException(e1.getMessage());
		}

		String ccResultString = new String(ccResult, StandardCharsets.UTF_8);
		System.out.println("Kalyan: queryEmployee: response string: " + ccResultString);
		ObjectMapper mapper1 = new ObjectMapper();
		Employee emp = mapper1.readValue(ccResultString, Employee.class);
		return new ResponseEntity<>(emp, HttpStatus.OK);
	} // get employee REST ends
	
	Contract contract = null;
	Gateway.Builder builder = null;
	Network network = null;
	Gateway gateway = null;
	NetworkConfig networkConfig = null;

	// ***** Do all initial setup to invoke/interact with chaincodes/contracts
	private void setup() {
		String networkConfigFilePath = "./network-config-tls.yaml";

		try {
			networkConfig = NetworkConfig.fromYamlFile(new File(networkConfigFilePath));
		} catch (InvalidArgumentException | NetworkConfigurationException | IOException e2) {
			e2.printStackTrace();
			throw new ChaincodeException(e2.getMessage());
		}

		OrgInfo clientOrg = networkConfig.getClientOrganization();
		NetworkConfig.CAInfo clientOrgCAInfo = clientOrg.getCertificateAuthorities().get(0);

		HFCAClient hfcaClient = null;
		try {
			hfcaClient = HFCAClient.createNewInstance(clientOrgCAInfo.getCAName(), clientOrgCAInfo.getUrl(),
					clientOrgCAInfo.getProperties());
		} catch (MalformedURLException | org.hyperledger.fabric_ca.sdk.exception.InvalidArgumentException e2) {
			e2.printStackTrace();
			throw new ChaincodeException(e2.getMessage());
		}

		CryptoSuite cryptoSuite = null;
		try {
			cryptoSuite = CryptoSuite.Factory.getCryptoSuite();
		} catch (IllegalAccessException | InstantiationException | ClassNotFoundException | CryptoException
				| InvalidArgumentException | NoSuchMethodException | InvocationTargetException e2) {
			e2.printStackTrace();
			throw new ChaincodeException(e2.getMessage());
		}
		
		hfcaClient.setCryptoSuite(cryptoSuite);

		// getting Client Org CA Registrars info (admin info)
		NetworkConfig.UserInfo registrarInfo = clientOrg.getCertificateAuthorities().get(0).getRegistrars().iterator()
				.next();

		String afficiation = "org1.department1";
		registrarInfo.setAffiliation("org1.department1");
		Enrollment adminEnrollment = null;
		try {
			adminEnrollment = hfcaClient.enroll(registrarInfo.getName(), registrarInfo.getEnrollSecret());
		} catch (EnrollmentException | org.hyperledger.fabric_ca.sdk.exception.InvalidArgumentException e2) {
			e2.printStackTrace();
			throw new ChaincodeException(e2.getMessage());
		}
		
		registrarInfo.setEnrollment(adminEnrollment);

		UserContext user1 = new UserContext();
		Date date = new Date();
		// This method returns the time in milli seconds
		long currentTimeInMilliSecs = date.getTime();
		String uniqueUserName = "User" + currentTimeInMilliSecs;
		user1.setName(uniqueUserName);
		user1.setMspId(clientOrg.getMspId());
		user1.setAffiliation(afficiation);
		Set<String> roles = new HashSet<String>();
		roles.add("client");
		user1.setRoles(roles);

		RegistrationRequest rr = null;
		try {
			rr = new RegistrationRequest(user1.getName(), user1.getAffiliation());
		} catch (Exception e1) {
			// TODO: Should take proper action here
			e1.printStackTrace();
		}
		
		String enrollmentSecret = null;
		try {
			enrollmentSecret = hfcaClient.register(rr, registrarInfo);
		} catch (RegistrationException | org.hyperledger.fabric_ca.sdk.exception.InvalidArgumentException e2) {
			e2.printStackTrace();
			throw new ChaincodeException(e2.getMessage());
		}

		Enrollment userEnrollment = null;
		try {
			userEnrollment = hfcaClient.enroll(user1.getName(), enrollmentSecret);
		} catch (EnrollmentException | org.hyperledger.fabric_ca.sdk.exception.InvalidArgumentException e2) {
			e2.printStackTrace();
			throw new ChaincodeException(e2.getMessage());
		}
		
		user1.setEnrollment(userEnrollment);
		
		// Load an existing wallet holding identities used to access the network.
		// First get the User Identity info that will be used to trigger transaction
		Path walletsDir = Paths.get("wallet");
		Wallet userWallet = null;
		try {
			userWallet = Wallet.createFileSystemWallet(walletsDir);
		} catch (IOException e1) {
			// TODO: Should take proper action here
			e1.printStackTrace();
		}
		
		Identity identity1 = new WalletIdentity("Org1MSP", userEnrollment.getCert(), userEnrollment.getKey());
		try {
			userWallet.put("user1", identity1);
		} catch (IOException e1) {
			e1.printStackTrace();
			throw new ChaincodeException(e1.getMessage());
		}

		// Path to a common connection profile describing the network.
		Path networkConfigFile = Paths.get(networkConfigFilePath);

		// Configure the gateway connection used to access the network.
		builder = null;
		try {
			builder = Gateway.createBuilder().identity(userWallet, "user1").networkConfig(networkConfigFile);
		} catch (IOException e1) {
			e1.printStackTrace();
			throw new ChaincodeException(e1.getMessage());
		}

		// Create a gateway connection
		try {
			gateway = builder.connect();

			// Obtain a smart contract deployed on the network.
			network = gateway.getNetwork("mychannel");
			contract = network.getContract("couchdb_java_simple"); // chaincode id
		} catch (Exception e) {
			e.printStackTrace();
			throw new ChaincodeException(e.getMessage());
		}
	} // setup ends
}

