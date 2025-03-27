package com.ginyon.common.utils.sign;

import org.apache.commons.codec.binary.Base64;

import javax.crypto.Cipher;
import java.security.*;
import java.security.interfaces.RSAPrivateKey;
import java.security.interfaces.RSAPublicKey;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;

/**
 * @author zwh
 * @description: RSA加密解密
 * @date: 2023/4/3 22:55
 */
public class RsaUtils {
    // Rsa 私钥
    public static String privateKey = "MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAJ/beFdAQLTC3nBn1hZ7fLJTOgu9btpRR6a4bIwVGy0gceMW9lGdHvcJj9onfxoWybYs2n6wPvESLlqrjKj1o6HdbwFeU8tl1KYuC37woPyrXihqbZVcw5kovwGaiIWdV4INonnNqsONilDnheRm+M8pjfszJP7ziCbfSkCSLNHhAgMBAAECgYBN9EGoEr47J/g/SnOdPRTfBTT+Op+POSm+xJqyaSx6giLngfAWdo9+Gpya3r3dpBUzkIXwV9QpzRrrvlJ2pmrnoAolWtMk2b6IEUZNARA8N7HLzbCV7PiJ8A6qiwxbdZsn8eJvz1EuP9V8mwW5smxVNTBzD3iymeGPtOol5nMOTQJBAPcLOL0vA9tIp4iuNE/gDbnunHbIAwSPHrqKFBiRw//jkDmdoG/Za8mZbe61KWFjnVXqk3Bj7lXLvyjWso5IfQMCQQClpxUxGaG70J7Bs6frqejdJ1SGXBCGmMJsBesx6wqOincQBVDt/I29Ccl4n9y4RHppWlVtB780BfFRM+w2C2ZLAkEAkjKR4WNxZNQaUUjGrH5roR0UezbiklAgX0RXoDKjS0vgjjg6OfbxUtz5scqEMp5A/hdUKa753Mw21HQ6NvmvAQJAEMVQrO7mY+hkGkJBDufdzn4L3ap2ddoDXQJgZGZiZDn6geG35tA53VifUBoHM5SjPAVMPsSZBABSBSGXmYUf7wJBAPKOc3W2k0YeQEzs4NrtRL5pV06H6O123UiP6Z3cQxAuyIxXLI2Xn8IMk4jB/zqgNovi68TkXBoohDLxxjSeFPg=";

    public static String publicKey = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCf23hXQEC0wt5wZ9YWe3yyUzoLvW7aUUemuGyMFRstIHHjFvZRnR73CY/aJ38aFsm2LNp+sD7xEi5aq4yo9aOh3W8BXlPLZdSmLgt+8KD8q14oam2VXMOZKL8BmoiFnVeCDaJ5zarDjYpQ54XkZvjPKY37MyT+84gm30pAkizR4QIDAQAB";

    /**
     * 私钥解密
     *
     * @param text 待解密的文本
     * @return 解密后的文本
     */
    public static String decryptByPrivateKey(String text) throws Exception {
        return decryptByPrivateKey(privateKey, text);
    }

    /**
     * 公钥解密
     *
     * @param publicKeyString 公钥
     * @param text            待解密的信息
     * @return 解密后的文本
     */
    public static String decryptByPublicKey(String publicKeyString, String text) throws Exception {
        X509EncodedKeySpec x509EncodedKeySpec = new X509EncodedKeySpec(Base64.decodeBase64(publicKeyString));
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        PublicKey publicKey = keyFactory.generatePublic(x509EncodedKeySpec);
        Cipher cipher = Cipher.getInstance("RSA");
        cipher.init(Cipher.DECRYPT_MODE, publicKey);
        byte[] result = cipher.doFinal(Base64.decodeBase64(text));
        return new String(result);
    }

    /**
     * 私钥加密
     *
     * @param privateKeyString 私钥
     * @param text             待加密的信息
     * @return 加密后的文本
     */
    public static String encryptByPrivateKey(String privateKeyString, String text) throws Exception {
        PKCS8EncodedKeySpec pkcs8EncodedKeySpec = new PKCS8EncodedKeySpec(Base64.decodeBase64(privateKeyString));
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        PrivateKey privateKey = keyFactory.generatePrivate(pkcs8EncodedKeySpec);
        Cipher cipher = Cipher.getInstance("RSA");
        cipher.init(Cipher.ENCRYPT_MODE, privateKey);
        byte[] result = cipher.doFinal(text.getBytes());
        return Base64.encodeBase64String(result);
    }

    /**
     * 私钥解密
     *
     * @param privateKeyString 私钥
     * @param text             待解密的文本
     * @return 解密后的文本
     */
    public static String decryptByPrivateKey(String privateKeyString, String text) throws Exception {
        PKCS8EncodedKeySpec pkcs8EncodedKeySpec5 = new PKCS8EncodedKeySpec(Base64.decodeBase64(privateKeyString));
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        PrivateKey privateKey = keyFactory.generatePrivate(pkcs8EncodedKeySpec5);
        Cipher cipher = Cipher.getInstance("RSA");
        cipher.init(Cipher.DECRYPT_MODE, privateKey);
        byte[] result = cipher.doFinal(Base64.decodeBase64(text));
        return new String(result);
    }

    /**
     * 公钥加密
     *
     * @param publicKeyString 公钥
     * @param text            待加密的文本
     * @return 加密后的文本
     */
    public static String encryptByPublicKey(String publicKeyString, String text) throws Exception {
        X509EncodedKeySpec x509EncodedKeySpec2 = new X509EncodedKeySpec(Base64.decodeBase64(publicKeyString));
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        PublicKey publicKey = keyFactory.generatePublic(x509EncodedKeySpec2);
        Cipher cipher = Cipher.getInstance("RSA");
        cipher.init(Cipher.ENCRYPT_MODE, publicKey);
        byte[] result = cipher.doFinal(text.getBytes());
        return Base64.encodeBase64String(result);
    }

    /**
     * 构建RSA密钥对
     *
     * @return 生成后的公私钥信息
     */
    public static RsaKeyPair generateKeyPair() throws NoSuchAlgorithmException {
        KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance("RSA");
        keyPairGenerator.initialize(1024);
        KeyPair keyPair = keyPairGenerator.generateKeyPair();
        RSAPublicKey rsaPublicKey = (RSAPublicKey) keyPair.getPublic();
        RSAPrivateKey rsaPrivateKey = (RSAPrivateKey) keyPair.getPrivate();
        String publicKeyString = Base64.encodeBase64String(rsaPublicKey.getEncoded());
        String privateKeyString = Base64.encodeBase64String(rsaPrivateKey.getEncoded());
        return new RsaKeyPair(publicKeyString, privateKeyString);
    }

    /**
     * RSA密钥对对象
     */
    public static class RsaKeyPair {
        private final String publicKey;
        private final String privateKey;

        public RsaKeyPair(String publicKey, String privateKey) {
            this.publicKey = publicKey;
            this.privateKey = privateKey;
        }

        public String getPublicKey() {
            return publicKey;
        }

        public String getPrivateKey() {
            return privateKey;
        }

        @Override
        public String toString() {
            return "RsaKeyPair{" +
                    "publicKey='" + publicKey + '\'' +
                    ", privateKey='" + privateKey + '\'' +
                    '}';
        }
    }
}
