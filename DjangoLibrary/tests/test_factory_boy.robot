*** Variables ***

${SERVER}               http://localhost:55001
${BROWSER}              firefox


*** Settings ***

Documentation   Testing Test Isolation
Library         Selenium2Library  timeout=10  implicit_wait=0
Library         DjangoLibrary  127.0.0.1  55001
Library         Collections
Library         DebugLibrary
Suite Setup     Start Django and Open Browser
Suite Teardown  Stop Django and Close Browser
Test Teardown   Manage Flush


*** Keywords ***

Start Django and open Browser
  Start Django
  Open Browser  ${SERVER}  ${BROWSER}

Stop Django and close browser
  Close Browser
  Stop Django


*** Test Cases ***

Test Factory Boy Keyword
  ${user}=  Factory Boy  DjangoLibrary.tests.factories.UserFactory
  # Log Dictionary  ${user}  WARN
  Dictionary Should Contain Key  ${user}  username
  Dictionary should contain key  ${user}  password
  Dictionary should contain item  ${user}  username  johndoe
  Dictionary should contain item  ${user}  email  johndoe@example.com
  Dictionary should contain item  ${user}  is_superuser  False
  Dictionary should contain item  ${user}  is_staff  False

Test Factory Boy Keyword Override Single Attribute
  ${user}=  Factory Boy  DjangoLibrary.tests.factories.UserFactory  username=janedoe
  # Log Dictionary  ${user}  WARN
  Dictionary should contain item  ${user}  username  janedoe
  Dictionary should contain item  ${user}  email  janedoe@example.com

Test Factory Boy Keyword Override Multiple Attribute
  ${user}=  Factory Boy  DjangoLibrary.tests.factories.UserFactory  username=janedoe  email=jane@doe.com
  # Log Dictionary  ${user}  WARN
  Dictionary should contain item  ${user}  username  janedoe
  Dictionary should contain item  ${user}  email  jane@doe.com

Test Factory Boy Keyword for Author
  ${user}=  Factory Boy  bookstore.factories.AuthorFactory
  # Log Dictionary  ${user}  WARN
  Dictionary Should Contain Key  ${user}  name
  Dictionary should contain item  ${user}  name  Noam Chomsky

Test Factory Boy Keyword for Book
  ${user}=  Factory Boy  bookstore.factories.BookFactory
  # Log Dictionary  ${user}  WARN
  Dictionary Should Contain Key  ${user}  title
  Dictionary should contain item  ${user}  title  Colorless Green Ideas Sleep Furiously

Test Factory Boy with non-existing path raises Exception
  ${expected_error}=  catenate  SEPARATOR=${SPACE}
  ...  HTTPError: Factory Boy class "Non.Existing.Path" could not be found
  Run Keyword and Expect Error  ${expected_error}  Factory Boy  Non.Existing.Path

Test Factory Boy with broken class raises Exception
  ${expected_error}=  catenate  SEPARATOR=${SPACE}
  ...  HTTPError: FactoryBoyClass
  ...  "DjangoLibrary.tests.factories.BrokenFactory"
  ...  could not be instantiated with args "{}"
  Run Keyword and Expect Error  ${expected_error}  Factory Boy  DjangoLibrary.tests.factories.BrokenFactory

Test Factory Boy class without meta class
  ${expected_error}=  catenate  SEPARATOR=${SPACE}
  ...  HTTPError: FactoryBoyClass
  ...  "DjangoLibrary.tests.factories.BrokenFactoryWithoutMetaClass"
  ...  could not be instantiated with args "{}"
  Run Keyword and Expect Error  ${expected_error}  Factory Boy  DjangoLibrary.tests.factories.BrokenFactoryWithoutMetaClass

Test Factory Boy class does not inherit from DjangoModelFactory
  ${expected_error}=  catenate  SEPARATOR=${SPACE}
  ...  HTTPError: The FactoryBoyClass
  ...  "DjangoLibrary.tests.factories.BrokenFactoryClassDoesNotInheritFromDjangoModelFactory"
  ...  instance does not seem to provide a _meta attribute.
  ...  Please check if the Factory Boy class inherits from DjangoModelFactory
  Run Keyword and Expect Error  ${expected_error}  Factory Boy  DjangoLibrary.tests.factories.BrokenFactoryClassDoesNotInheritFromDjangoModelFactory