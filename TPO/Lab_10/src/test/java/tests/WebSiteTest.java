package tests;

import org.openqa.selenium.Dimension;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.Assert;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;

import java.time.Duration;

import pages.CallOrderPage;
import pages.HomePage;
import pages.ProductPage;

public class WebSiteTest {
    private WebDriver driver;
    private WebDriverWait wait;
    private HomePage homePage;
    private ProductPage productPage;

    @BeforeMethod
    public void setUp() {
        driver = new ChromeDriver();
        driver.manage().window().setSize(new Dimension(1920, driver.manage().window().getSize().getHeight()));
        wait = new WebDriverWait(driver, Duration.ofSeconds(10));
        homePage = new HomePage(driver, wait);
        productPage = new ProductPage(driver, wait);
    }



    @Test
    public void testCallBack() throws InterruptedException {
        homePage.openWebsite("https://7745.by/");
        Thread.sleep(2000);
        homePage.clickCallOrderButton();
        Thread.sleep(2000);
        homePage.enterName("Александр Алексеевский Григорьевич");
        homePage.selectPrefix("+375");
        homePage.enterPhone("291321672");
        homePage.enterNote("хочу протестировать лабу на вашем сайте");
        homePage.acceptPolicy();
        homePage.submitButtonClick();
        Thread.sleep(2000);
        Assert.assertTrue(homePage.isRequestAccepted());

    }

    @Test
    public void addToFavouriteTest() {
        homePage.openWebsite("https://7745.by/");

        homePage.enterSearchText("iphone");
        homePage.clickSearchButton();

        productPage.hoverOverBuyButton();
        productPage.scrollIntoView(productPage.getBuyButton());
        productPage.clickBuyButton();

        productPage.clickProductLink();

        assert productPage.isAddedButtonDisplayed();
    }

    @AfterMethod
    public void tearDown() {
        driver.quit();
    }
}