import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPasswordField;
import javax.swing.JTextField;
import java.util.Scanner;

import oracle.jdbc.pool.OracleDataSource;

/**
 * This class demonstrates how to use JDBC in Java, and how to use
 * transactions.
 * 
 * The code below assumes that you have created the table below in
 * the Oracle that is running on Akka.
 * 
 * CREATE TABLE professor(emp_id VARCHAR2(64),
 *     first_name VARCHAR2(64),
 *     middle_name VARCHAR2(64),
 *     last_name VARCHAR2(64),
 *     PRIMARY KEY(emp_id));
 *     
 * Remember that you need to use UMD's VPN client to access Akka if
 * you are located outside of the UMD network.
 *
 * Original file author eleal
 * 
 * Edited for the purpose of this final project by Avery Kiser
 *
 */

public class Simple {

	String jdbcUrl = "jdbc:oracle:thin:kiser017@//akka.d.umn.edu:1521/xe";
	// For security reasons, never PUT YOUR PASSWORD
	// IN YOUR SOURCE FILE LIKE THIS:
	// String password = "This is my password. Now, steal my money!";
	Connection conn;

	/**
	 * This class gets the current DB connection. This is not to be used in
	 * production environments. You should use a connection pool instead.
	 *
	 * @return
	 * @throws SQLException
	 */
	public Connection getDBConnection() throws SQLException{ 
		OracleDataSource ds = new OracleDataSource(); 
		ds.setURL(jdbcUrl);

		if(conn == null) {
			// Display a message to get the password from the user 
			JLabel label = new JLabel("Oracle Username: "); 
			JTextField jtf = new JTextField();
			JLabel label2 = new JLabel("Oracle Password:"); 
			JPasswordField jpf = new JPasswordField(); 
			JOptionPane.showConfirmDialog(null,
					new Object[]{label, jtf, label2, jpf}, 
					"Password:", JOptionPane.OK_CANCEL_OPTION);

			String password = String.valueOf(jpf.getPassword());
			conn = ds.getConnection(jtf.getText(), password );
		}
		conn.setAutoCommit(true);
		return conn;
	}

	/**
	 * This class takes the user input from the person running the 
	 * query and tries to run the desired query that they wish to run. 
	 * JDBC is also stupid and was not letting me use the dates.
	 *
	 * @throws SQLException
	 */
	//Scanner syntax found from w3schools.com
	public static void main(String[] args) throws Exception{ 
		Simple q = new Simple();
		q.getDBConnection();
		
		Scanner userIn = new Scanner(System.in);
		System.out.println("Enter 1 or 2 for your desired query");
		System.out.println("1 for patients prescriptions, 2 for top 3 drugs");
		int response = userIn.nextInt();
		
		if(response == 1) {
			Scanner patientName = new Scanner(System.in);
			System.out.println("Enter the patient's name");
			String newName = patientName.nextLine();
			
			Scanner DOB = new Scanner(System.in);
			System.out.println("Give the patients Date of birth in yyyy-mm-dd "
					+ "with the dashes");
			String date = DOB.nextLine();
			
			q.findPrescription(newName, date);
		}
		
		if(response == 2) {
			q.findTopDrugs();
		}
		
	}

	
	/**
	 * This is meant to satisfy query 1 for the project
	 * Query.- finds prescriptions for patients when given
	 * their name and DOB on file
	 * 
	 * Does not fully function, takes the information but throws an error
	 *
	 * @throws SQLException
	 */
	public void findPrescription(String name, String DOB)
					throws SQLException {
		
		// Connect to the database. 
		getDBConnection();

		// Grabs information from the database
		String findPatient =
				"SELECT drug_name"
				+ " FROM patient JOIN prescription ON patient.patient_name"
				+ " = prescription.patient"
				+ " WHERE patient_name = ? AND DOB = DATE ?";
		
		// You can read about this type of Try-catch block. It's called
		// "try with resources." It's relatively new to Java: since Java 7. 
		try(PreparedStatement drugSelectStmt =
				conn.prepareStatement(findPatient);) {

			drugSelectStmt.setString(1, name);
			drugSelectStmt.setString(2, DOB);
			
			// Run the insert drug selection into query
			ResultSet rs  = drugSelectStmt.executeQuery();
			
			while(rs.next()){
		         //retrieve the name of the drug that the patient takes. 
		         String drug_name  = rs.getString("drug_name");		         
		         
		         System.out.println(drug_name);
			}

		} catch(SQLException e) {
			e.printStackTrace(); 
		} 
	}
	
	/**
	 * This is meant to satisfy query 2 of the project
	 * Query.- finds the top 3 drugs listed and lists them
	 * in order from most prescribed to least prescribed.
	 * 
	 * This query does work
	 *
	 * @throws SQLException
	 */
	public void findTopDrugs()
			throws SQLException {

		// Connect to the database. 
		getDBConnection();

		// Grabs information from the database regarding drugs
		String findDrugsRanked =
				"SELECT drug_name, COUNT(drug_name) AS drug_ranked"
						+ " FROM prescription" 
						+ " WHERE ROWNUM <= 4" 
						+ " GROUP BY drug_name"
						+ " ORDER BY drug_ranked DESC";

		// You can read about this type of Try-catch block. It's called
		// "try with resources." It's relatively new to Java: since Java 7. 
		try(PreparedStatement drugSelectStmt =
				conn.prepareStatement(findDrugsRanked);) {

	
			// Run the drug counting query
			ResultSet rs  = drugSelectStmt.executeQuery();
	
			while(rs.next()){
				//prints the drugs in order from most prescribed to least
				String drug_name  = rs.getString("drug_name");
				String drug_ranked = rs.getString("drug_ranked");
         
				System.out.println(drug_name + " " + drug_ranked);
			}

		} catch(SQLException e) {
			e.printStackTrace(); 
		} 
}
}
