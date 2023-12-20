package pages;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

public class ProductPage {
    private WebDriver driver;
    private WebDriverWait wait;
    private By buyButton = By.cssSelector(".action-btn--favourites[data-articul='862193']");
    private By productLink = By.partialLinkText("iPhone 14 Plus 128GB Blue");
    private By addedButton = By.cssSelector(".cursor-pointer.action-btn--favourites-added");

    public ProductPage(WebDriver driver, WebDriverWait wait) {
        this.driver = driver;
        this.wait = wait;
    }

    public WebElement getBuyButton() {
        return driver.findElement(buyButton);
    }

    public void hoverOverBuyButton() {
        Actions actions = new Actions(driver);
        actions.moveToElement(getBuyButton()).build().perform();
    }

    public void scrollIntoView(WebElement element) {
        ((JavascriptExecutor) driver).executeScript("arguments[0].scrollIntoView({block: 'center', inline: 'center'});", element);
    }

    public void clickBuyButton() {
        WebElement buyButtonElement = wait.until(ExpectedConditions.elementToBeClickable(buyButton));
        buyButtonElement.click();
    }

    public void clickProductLink() {
        WebElement productLinkElement = wait.until(ExpectedConditions.elementToBeClickable(productLink));
        productLinkElement.click();
    }

    public boolean isAddedButtonDisplayed() {
        WebElement addedButtonElement = wait.until(ExpectedConditions.presenceOfElementLocated(addedButton));
        return addedButtonElement.isDisplayed();
    }
}