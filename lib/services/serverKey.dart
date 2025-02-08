import 'package:googleapis_auth/auth_io.dart';

class get_server_key {
  Future<String> server_token() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];
    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "yukbultr",
          "private_key_id": "f68be8a40604e5eb78a45a38a32fb8827a26fbe5",
          "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCtNGbo/06H6H9L\nZhvodwGT1Obj+WmAvGEc5YhlriLo5YdQAlg3J3KYCjUST+C1wPWtJUCm+vCeNyTq\n2+pB8v/wQdOflDDl11tp8BV9QS1S75FHwJ5J7w9/VPmd80u1lY4R/2JNHhbi3KsE\nJbpJeZOKFknY5Ro4pLZG9eH/uI5+oMuibCiWSVme88ROQJgHSWYOYnzceCC7bYA1\n1tjCe6TInWVVD0S/vQw1r/Ah/ym4vbbUEGFpbuGxiZELiBuFVf+hzKMh66skdPr/\nNvEa2dvzhSo+flgOrg1TwKnsgAgWD+G2yLLQ3QLAe/vNQfUls/p2ogpePA6pIHHw\n1XdVaPr7AgMBAAECggEASxKpgFgYu8PEWPP7KLlcT606HpoeZpRAK3w5sIjXzMaf\n7cf2YIGSo9/YvQUuStlGIzRAX5/o50rTj5CeatNep86AYWyj/RtpHfPX/KBhes8n\n00fj0/vwZap5P0MTD7OxDo/5FZ/zH4WyAmwv4GT31CRxAbfbs62A7CTrPiHKcYuc\npBVRdHzqGriHto6WV1rJlP3Z6HJlpaVRTnkUBv/qEVW9fGHqxzd+inJ217r2zAhU\nKrt+iP3P5IzrkXFQxJDlSOx5zOI2PEpEw91/PMIpkCsKvXRcIdCUuTgFpCGjWDlR\nxilaI6GCFNm3EwfGH4S8RboUz30zPnXHq7cA+oNFoQKBgQDtGVscdhgQMsoKQDgO\nBf94mojxNJjQHpDlTRTmCbjLKjenpXDuNVPkHCwFNdlhn0ITuFkhPRnczovKdAK/\n6LYCNEGN6hmVdY2qaNFouB9RzWItnauWfeQSz1I2yqKdOp2MjmesASFUcXuwlM25\nS3a7WPUTQMS2LNEGc3Qg05IZkwKBgQC7Axwi8kNcIpTzJW0f/HvvzDXXFcOcUI5R\nFVQRLqQXRNFt2uHiBV7ZUNKwxiwIBeFdZgPqNer96HIDh2rOWyChk8+ot5hg7i68\nXzjAFCE9U3+ftUn9sXqO8yFerFpCRIEvSxDVYTqcbNnwTIaJQWcnsrdFN/GiY3aj\nxDEd0y5Z+QKBgEQPvEzeRagYvFDXAIBeDmkTi24aWCeeLp/0UaR7c/W2R8WzQ0jO\nPCfGQoi4XY+dhP1eNQ/Kl2sAS7axOLzYU68sSwkvA2sZFLKvZjW2bR8xYxaPJVuN\nBfS0WPhrkOSrl+BqXK5OoL+51/TnsmqXlBzRu4BsXkuhb9t3NwXZVh5LAoGBAIRx\nqWWeidIgs7iX0vcKS4QC7kaLpWN5MbF/F3CrxY6tMF1K3RrDju79bJnBX8G22Grb\nKv6efPShwM17BEttAmksU687h3Fufi7uiTSPjRLvpb0oGWTQYuoGiqWQDsRL2+nw\nkdVs7KOH+7lRmR5v8WyOB3nAKyNEqetFsTtcKsGRAoGBAOX/A7ij7PjyIB5ORTit\n1xMjPmr6Yv7Cy6NKBjP53R2hP3tJ9er9DUFxPVvZrUTsm1XY9fp1sd9wRXtBCpET\nyNO1SewZNg1ZmqJkq4JM9H3sY+niyIbS9U+/Gvuij4geu2z0wutf9a4KnajbHTRz\nsYsiMugTord/mG4CfEC4UHiM\n-----END PRIVATE KEY-----\n",
          "client_email": "firebase-adminsdk-s11c0@yukbultr.iam.gserviceaccount.com",
          "client_id": "108037952352600440166",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-s11c0%40yukbultr.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }),
        scopes);
    final accessserverkey = client.credentials.accessToken.data;
    return accessserverkey;
  }
}