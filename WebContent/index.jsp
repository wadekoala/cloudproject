<%@ 
page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"

import="cht.ccsdk.info.mod.pkg.api.*"
import="cht.ccsdk.info.mod.api.pkg.exception.*"
import="cht.ccsdk.bean.*"
import="cht.ccsdk.proxy.*"
import="org.apache.commons.httpclient.*"
import="org.apache.commons.httpclient.methods.*"
import="java.io.*"
%>
<%!
public String getModPkgInfo(String isvAccount, String sdkKey)
	    throws Exception
	  {
			System.out.println("in getModPkgInfo");
	    String result = null;

	    ServiceManager srvmgr = null;
	    AuthTokenBean authTokenbean = null;

	    boolean authResult = false;
	    try
	    {
	      String timestamp = Long.toString(ServiceManager.genTimestamp());
	      String nonce = ServiceManager.genNonce();
	      System.out.println("nonce" + nonce);
	      srvmgr = new ServiceManager("http", "api.hicloud.hinet.net", 80, null);
	      if(srvmgr == null)  System.out.println("srvmgr is null");
	      authTokenbean = srvmgr.requestToken(isvAccount, "41", nonce, timestamp, ServiceManager.genSign(sdkKey + nonce + timestamp, "SHA"));
	      if(authTokenbean == null)  System.out.println("authTokenbean is null");
	      
	
			
	      if (srvmgr.getResultCode() == 0)
	      {
	        authResult = true;
	      }
	      else
	      {
	        throw new IsvAccountAuthErrorException("[1005] isvAccount auth error code=" + srvmgr.getResultCode() + ",message=" + srvmgr.getErrMsg());
	      }

	    }
	    catch (IsvAccountAuthErrorException ex)
	    {
	      throw new Exception(ex.getMessage());
	    }
	    catch (Exception ex)
	    { 
	      ex.printStackTrace();
	      throw new Exception("[1008] Unknown error:" + ex.getMessage());
	    }

	    try
	    {
	      HttpClient client = new HttpClient();

	      GetMethod method = new GetMethod("http://cht-mod-api.hicloud.net.tw:9100/ModPkgInfoService/data/ModPkgInfo/getModPkgInfo");

	      System.out.println("isvAccount " +  isvAccount);
	      System.out.println("authTokenbean.getToken() " + authTokenbean.getToken());
	      System.out.println("authTokenbean.getSign() " + authTokenbean.getSign());
	      
	      method.addRequestHeader("isvAccount", isvAccount);
	      method.addRequestHeader("token", authTokenbean.getToken());
	      method.addRequestHeader("sign", authTokenbean.getSign());

	      method.getParams().setContentCharset("UTF-8");

	      int statusCode = client.executeMethod(method);

	      if (statusCode == 200)
	      {
	        InputStream resStream = method.getResponseBodyAsStream();
	        BufferedReader br = new BufferedReader(new InputStreamReader(resStream, "utf-8"));
	        StringBuffer resBuffer = new StringBuffer();
	        String resTemp = "";
	        while ((resTemp = br.readLine()) != null)
	        {
	          resBuffer.append(resTemp);
	        }

	        result = resBuffer.toString();
	      }
	      else
	      {
	        throw new ModInfoServiceErrorException("[1006] request service fail,http status=" + statusCode);
	      }

	    }
	    catch (ModInfoServiceErrorException ex)
	    {
	      throw new Exception(ex.getMessage());
	    }
	    catch (Exception ex)
	    {
	   	  ex.printStackTrace();
	      throw new Exception("[1008] Unknown error:" + ex.getMessage());
	    }

	    return result;
	  }


%>
<!doctype html>
<html>
<head>
	<meta charset=utf-8>
	<title>project title</title>
</head>
<body>
TEST2
<%

try
{
	out.println(getModPkgInfo("367f7deaa1ce47b185a0c91cb6d8f714", "n+ABj+1w6e1Ht2A2ziBh0Q==")); // ++ 請輸入雲元件isvaccount, sdkkey
	//out.println(getModPkgInfo("ISVTEST", "n+ABj+1w6e1Ht2A2ziBh0Q==")); // ++ 請輸入雲元件isvaccount, sdkkey
}
catch(Exception ex)
{
	ex.printStackTrace();
	out.println(ex.getMessage());
}

%>

TEST3
</body>
</html>
