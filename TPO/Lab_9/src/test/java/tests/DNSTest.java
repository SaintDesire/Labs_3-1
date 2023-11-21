package tests;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.Assert;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;
import pages.CustomCondition;

import java.time.Duration;

public class DNSTest {
    private WebDriver driver;
    private int initialWishlistCount;

    @BeforeMethod
    public void setUp() throws InterruptedException {
        String driver_home = "C:\\webdriver";
        ChromeOptions chrome_options = new ChromeOptions();
        chrome_options.addArguments("--window-size=1920,1080");

        chrome_options.addArguments("--headless=new");

        ChromeDriver chromeDriver1 = new ChromeDriverBuilder()
                .build(chrome_options,driver_home);
        chromeDriver1.get("https://dns-shop.ru");
        new WebDriverWait(driver, Duration.ofSeconds(5)).until(CustomCondition.jQueryAJAXsCompleted());
    }

    @Test
    public void checkAddToWishlist() throws InterruptedException {
        // Поиск элемента с классом wishlist-link-counter__badge
        WebElement wishlistCounter = driver.findElement(By.xpath("//span[@class='wishlist-link-counter__badge']"));

        // Запись начального значения в переменную
        initialWishlistCount = wishlistCounter.isDisplayed() ?
                Integer.parseInt(wishlistCounter.getText()) : 0;

        // Поиск элемента с классом presearch__input и ввод текста "Iphone 13"
        WebElement searchInput = driver.findElement(By.xpath("//input[@class='presearch__input']"));
        searchInput.sendKeys("Iphone 13");

        // Поиск элемента с классом presearch__icon-search и нажатие на него
        WebElement searchIcon = driver.findElement(By.xpath("//button[@class='presearch__icon-search']"));
        searchIcon.click();

        // Поиск элемента с текстом "6.1" Смартфон Apple iPhone 13 128 ГБ черный [...]"
        WebElement iphoneElement = driver.findElement(By.xpath("//div[contains(text(),'6.1\" Смартфон Apple iPhone 13 128 ГБ черный')]"));
        iphoneElement.click();

        // Поиск элемента с классом wishlist-btn и нажатие на него
        WebElement wishlistButton = driver.findElement(By.xpath("//button[@class='wishlist-btn']"));
        wishlistButton.click();

        // Поиск элемента с классом wishlist-link-counter__badge после добавления в избранное
        WebElement updatedWishlistCounter = driver.findElement(By.xpath("//span[@class='wishlist-link-counter__badge']"));

        // Проверка, что количество в избранном увеличилось
        int updatedCount = updatedWishlistCounter.isDisplayed() ?
                Integer.parseInt(updatedWishlistCounter.getText()) : 0;

        Assert.assertTrue(updatedCount > initialWishlistCount, "Количество в избранном не увеличилось");
    }


    @AfterMethod
    public void tearDown() {

        driver.quit();
    }
}
