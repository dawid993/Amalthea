
public class EE_DAO_UserDao {

	public static User getUserById(ID userId){
		List<User> users = [SELECT
								ID,
								Name,
								Country__c
							FROM
								User
							WHERE
								ID = :userId];
		return users != null && !users.isEmpty() ? users[0] : null;
	}
}