package pages;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.Select;
import org.openqa.selenium.support.ui.WebDriverWait;

public class HomePage {
    private WebDriver driver;
    private WebDriverWait wait;
    @FindBy(className = "ui-autocomplete-input")
    private WebElement inputField;

    @FindBy(className = "btn-search")
    private WebElement searchButton;
    @FindBy(xpath = "(//input[@id='recall-name'])[2]")
    private WebElement recallNameField;
    @FindBy(xpath = "//button[contains(@class, 'js-accept-cookies')]")
    private WebElement cookiesButton;
    @FindBy(xpath = "(//select[@id='recall-phone-country'])[2]")
    private WebElement prefixSelect;

    @FindBy(xpath = "(//input[@id='recall-phone'])[2]")
    private WebElement recallPhoneField;

    @FindBy(xpath = "(//textarea[@id='recall-note'])[2]")
    private WebElement recallNoteField;

    @FindBy(xpath = "(//input[@name='accepted_policy'])[3]")
    private WebElement acceptedPolicyCheckbox;
    @FindBy(xpath = "(//input[@value='Жду звонка'])[2]")
    private WebElement submitButton;
    public HomePage(WebDriver driver, WebDriverWait wait) {
        this.driver = driver;
        this.wait = wait;
        PageFactory.initElements(driver, this);
    }

    public void enterName(String name) {
        recallNameField.sendKeys(name);
    }

    public void selectPrefix(String prefix) {
        Select select = new Select(prefixSelect);
        select.selectByVisibleText(prefix);
    }

    public void enterPhone(String phone) {
        recallPhoneField.sendKeys(phone);
    }

    public void enterNote(String note) {
        recallNoteField.sendKeys(note);
    }

    public void acceptPolicy() {
        acceptedPolicyCheckbox.click();
    }
        public void submitButtonClick() throws InterruptedException {
            JavascriptExecutor js = (JavascriptExecutor) driver;

            WebElement submitButtonElement = wait.until(ExpectedConditions.visibilityOf(submitButton));
            js.executeScript("arguments[0].scrollIntoViewIfNeeded();", submitButtonElement);
            Actions actions = new Actions(driver);
            actions.moveToElement(submitButtonElement).click().perform();
            Thread.sleep(2000);
            driver.switchTo().frame(driver.findElement(By.cssSelector("iframe[title='reCAPTCHA']")));
            WebElement captchaCheckbox = driver.findElement(By.xpath("//span[@id='recaptcha-anchor']/div[@class='recaptcha-checkbox-border']"));
            captchaCheckbox.click();
            driver.switchTo().defaultContent();
            Thread.sleep(2000);
            submitButton.click();
        }
    public boolean isRequestAccepted() {
        WebElement messageElement = driver.findElement(By.xpath("//div[contains(text(), 'Ваш запрос принят в обработку!')]"));
        return messageElement.isDisplayed();
    }
    public void enterSearchText(String searchText) {
        WebElement inputFieldElement = wait.until(ExpectedConditions.visibilityOf(inputField));
        inputFieldElement.sendKeys(searchText);
    }

    public void clickSearchButton() {
        WebElement searchButtonElement = wait.until(ExpectedConditions.elementToBeClickable(searchButton));
        searchButtonElement.click();
    }

    public void openWebsite(String url) {
        driver.get(url);
    }


    public void clickCallOrderButton() {
        JavascriptExecutor js = (JavascriptExecutor) driver;

        WebElement callOrderButtonElement = wait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector(".call-order.open-popup.d-flex")));
        js.executeScript("arguments[0].scrollIntoViewIfNeeded();", callOrderButtonElement);

        callOrderButtonElement = wait.until(ExpectedConditions.elementToBeClickable(By.cssSelector(".call-order.open-popup.d-flex")));
        callOrderButtonElement.click();

        cookiesButton.click();
    }

}