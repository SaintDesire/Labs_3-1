package pages;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

public class CallOrderPage {
    private WebDriver driver;
    private WebDriverWait wait;
    private By nameInput = By.id("recall-name");
    private By prefixSelect = By.name("prefix");
    private By phoneInput = By.id("recall-phone");
    private By noteInput = By.id("recall-note");

    public CallOrderPage(WebDriver driver) {
        this.driver = driver;
    }

    public void enterName(String name) {
        WebElement nameInputElement = wait.until(ExpectedConditions.elementToBeClickable(nameInput));
        nameInputElement.clear();
        nameInputElement.sendKeys(name);
    }

    public void selectPrefix(String prefix) {
        WebElement prefixSelectElement = wait.until(ExpectedConditions.elementToBeClickable(prefixSelect));
        prefixSelectElement.click();
        prefixSelectElement.sendKeys(prefix);
    }

    public void enterPhone(String phone) {
        WebElement phoneInputElement = wait.until(ExpectedConditions.elementToBeClickable(phoneInput));
        phoneInputElement.clear();
        phoneInputElement.sendKeys(phone);
    }

    public void enterNote(String note) {
        WebElement noteInputElement = wait.until(ExpectedConditions.elementToBeClickable(noteInput));
        noteInputElement.clear();
        noteInputElement.sendKeys(note);
    }

    public void submitOrder() {
        // Дополнительные действия для отправки заказа, если таковые есть
    }
}