package tests;

import org.openqa.selenium.*;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;

import java.time.Duration;

public class WebSiteTest {
    private WebDriver driver;
    private WebDriverWait wait;

    @BeforeMethod
    public void setUp() {
        driver = new ChromeDriver();
        driver.manage().window().setSize(new Dimension(1920, driver.manage().window().getSize().getHeight()));
        wait = new WebDriverWait(driver, Duration.ofSeconds(10));
    }

    @Test
    public void addToFavouriteTest() {
        driver.get("https://7745.by");

        WebElement inputField = driver.findElement(By.className("ui-autocomplete-input"));
        inputField.sendKeys("rtx 4070");

        WebElement searchButton = wait.until(ExpectedConditions.elementToBeClickable(By.className("btn-search")));
        searchButton.click();

        WebElement buyButton = wait.until(ExpectedConditions.elementToBeClickable(By.cssSelector(".action-btn--favourites[data-articul='876821']")));

        // Прокрутка страницы до элемента
        ((JavascriptExecutor) driver).executeScript("arguments[0].scrollIntoView({block: 'center', inline: 'center'});", buyButton);
        // Ожидание, чтобы убедиться, что элемент становится видимым
        wait.until(ExpectedConditions.visibilityOf(buyButton));

        buyButton.click();

        WebElement productLink = wait.until(ExpectedConditions.elementToBeClickable(By.linkText("Видеокарта MSI RTX 4070 GAMING X SLIM WHITE 12G (RTX 4070 GAMING X SLIM WHITE 12G)")));
        productLink.click();

        WebElement addedButton = wait.until(ExpectedConditions.presenceOfElementLocated(By.cssSelector(".cursor-pointer.action-btn--favourites-added")));

        assert addedButton != null;
    }

    @AfterMethod
    public void tearDown() {
        driver.quit();
    }
}