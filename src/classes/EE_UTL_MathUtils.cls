public class EE_UTL_MathUtils {
	public static String hash(String valueToHash) {
		Blob targetBlob = Blob.valueOf(valueToHash);
		Blob hash = Crypto.generateDigest('SHA1', targetBlob);
		return EncodingUtil.base64Encode(hash);
	}
}