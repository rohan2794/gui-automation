import time
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as ec


class BasePage(object):
    def __init__(self, driver):
        self.driver = driver

    def wait_element_present(self, *locator):
        self.driver.implicitly_wait(5)
        WebDriverWait(self.driver, 60).until(ec.presence_of_element_located(*locator))
        return WebDriverWait(self.driver, 60).until(ec.element_to_be_clickable(*locator))

    def wait_element_visible(self, *locator):
        self.driver.implicitly_wait(5)
        WebDriverWait(self.driver, 30).until(ec.presence_of_element_located(*locator))
        return WebDriverWait(self.driver, 30).until(ec.presence_of_element_located(*locator))

    def wait_elements_visible(self, *locator):
        self.driver.implicitly_wait(5)
        WebDriverWait(self.driver, 30).until(ec.presence_of_element_located(*locator))
        return WebDriverWait(self.driver, 30).until(ec.presence_of_all_elements_located(*locator))

    @staticmethod
    def sleep(wait_time):
        time.sleep(wait_time)

    def find_element_by_id(self, locator):
        self.driver.implicitly_wait(5)
        return self.driver.find_element_by_id(locator)

    def navigate_to(self, page):
        self.driver.get(page)