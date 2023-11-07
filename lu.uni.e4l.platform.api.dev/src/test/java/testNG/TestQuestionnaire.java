package testNG;

import java.net.MalformedURLException;
import java.net.URL;

import org.json.JSONException;
import org.openqa.selenium.By;
import org.openqa.selenium.Platform;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.remote.RemoteWebDriver;
import org.testng.Assert;
import org.testng.annotations.AfterSuite;
import org.testng.annotations.BeforeTest;
import org.testng.annotations.Test;
import org.json.simple.JSONValue;
import org.json.simple.parser.ParseException;

public class TestQuestionnaire {

	private static WebDriver driver;
	private static String serverBaseURL = System.getProperty("serverBaseURL");
	private static String webpageURI = "/e4lapi/questionnaire";

	@BeforeTest
	// Local run
	// public static void configureDriver() {
	// // Set the path to your local ChromeDriver executable
	// System.setProperty("webdriver.chrome.driver",
	// "/Users/flavio/Installs/chromedriver_mac64/chromedriver");

	// ChromeOptions chromeOptions = new ChromeOptions();
	// chromeOptions.addArguments("--headless");
	// chromeOptions.addArguments("--no-sandbox");
	// chromeOptions.addArguments("--disable-dev-shm-usage");
	// chromeOptions.addArguments("--window-size=1200x600");

	// // Create a ChromeDriver instance
	// driver = new ChromeDriver(chromeOptions);
	// }
	public static void configureDriver() throws MalformedURLException {
		final ChromeOptions chromeOptions = new ChromeOptions();
		chromeOptions.addArguments("--headless");
		chromeOptions.addArguments("--no-sandbox");
		chromeOptions.addArguments("--disable-dev-shm-usage");
		chromeOptions.addArguments("--window-size=1200x600");

		chromeOptions.setBinary("/usr/bin/google-chrome");
		DesiredCapabilities capability = DesiredCapabilities.chrome();
		capability.setBrowserName("chrome");
		capability.setPlatform(Platform.LINUX);

		capability.setCapability(ChromeOptions.CAPABILITY, chromeOptions);

		driver = new RemoteWebDriver(new URL("http://selenium__standalone-chrome:4444/wd/hub"), capability);
	}

	@Test
	public static void testQuestionnaireJson() throws InterruptedException {
		driver.get(serverBaseURL + webpageURI);
		Thread.sleep(1000);

		String pageSource = driver.findElement(By.tagName("pre")).getText();

		Assert.assertTrue(isValidJSON(pageSource));

		Thread.sleep(1000);
	}

	public static boolean isValidJSON(String json) {
		try {
			JSONValue.parseWithException(json);
			return true;
		} catch (ParseException e) {
			return false;
		}
	}

	@AfterSuite
	public static void closeDriver() {
		driver.quit();
	}

}
