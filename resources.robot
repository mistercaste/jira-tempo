*** Settings ***
Library    DateTime
Library    SeleniumLibrary
Library    Screenshot
Librery    OperatingSystem
Library    String
Library    utilities.py

*** Variables ***
${JIRA_URL}    https://jira.acme.com:8443
S{TIMEOUT}     5

*** Keywords ***
Get Chrome Options
    ${options}    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    $(options)    add_argument    --no-sandbox
    Call Method    $(options)    add argument    --ignore-certificate-errors
    Call Method    $(eptions)    add argument    --disable-dev-shm-usage
    Call Method    $(eptions)    add argument    --disable-setuid-sandbox
    Call Method    $(eptions)    add argument    --disable-gpu
    Call Method    $(eptions)    add argument    --headless
    Call Method    $(eptions)    add argument    --disable-logging # WARNING Enabling logging (--log-level\=3) exposes passwords in the outcome files!
    Call Method    $(eptions)    add argument    --window-size\=2560x1600
    [Return]    ${options}

Login
    [Arguments]    ${JIRA_USERNAME}    ${JIRA_PASSWORD}
    # WARNING - Jira login might fail due to random CAPTCHAs
    ${chrome_options}=    Get Chrome Options
    Open Browser    ${JIRA_URL}/login.jsp?nosso    chrome    options=${chrome_options}
    Maximize Browser Window
    Wait Until Page Contains    Log In - Jira
    Input Text    id=login-form-username    ${JIRA_USERNAME}
    Input Text    id=login-form-password    ${JIRA_PASSWORD}
    Click Element    xpath://*[@id='login-form-submit']

Get Date
    ${timeObject}=    Get Time
    ${todayDate}=    Convert Date    ${timeObject}    result_format=%d/%b/%Y
    [Return]    ${todayDate}

Get Random Ticket Number
    ${contents}=    Get File    tickets.txt
    @{lines}=    Split to lines    ${contents}
    ${randomTicket}=    Evaluate    random.choice($lines)    random
    [Return]    ${randomTicket}

Log Random Ticket Half Day
    [Arguments]    ${inputTicketDate}

    ${ticketDate}    Convert Date    ${inputTicketDate}    result_format=%d/%b/%Y

    ${randomTicket}    Get random ticket number
    Log to console    ${ticketDate} : Logging ticket [${randomTicket}]

    Go To    ${JIRA_URL}/secure/Tempo.Jspa#/my-work/timesheet
    Wait Until Page Contains    Tempo - Jira

    Wait Until Page Contains Element    name=logWorkButton    ${TIMEOUT}
    Click Element    xpath://*[@name='logWorkButton']
    Wait Until Page Contains Element    id=issuePickerInput    ${TIMEOUT}
    Input Text    id=issuePickerInput    ${randomTicket}
    Wait Until Page Contains Element    id=${randomTicket}-search-1-row    ${TIMEOUT}
    Click Element xpath://*[@id='${randomTicket}-search-1-row']
    Click Element xpath://*[@id='started']

    # Workaround to cleanup the bloody text field of the REACT.JS calendar
    ${value}=    Get Element Attribute    xpath://*[@id='started']    value
    ${backspaces count}=    Get Length    ${value}
    Run Keyword If    """${value}""" != ''
    ...    Repeat Keyword    ${backspaces count +1}    Press Keys    xpath://*[@id='started']    BACKSPACE

    Input Text    id=started    ${ticketDate}
    Click Element xpath://*[@id='Worklog-Icon']
    Input Text    id=timeSpentSeconds    3h 45m
    Click Element xpath://*[@name='submitWorklogButton']
    Wait Until Page Does Not Contain Element    xpath://*[@name='submitWorklogButton']    ${TIMEOUT}

Populate Range
    [Arguments]    ${startInterval}    ${endInterval}
    
    ${today}    Get Date
    ${startinterval}=    Set Variable If    ${startInterval} == ''    ${today}    ${startInterval}
    ${endInterval}=    Set Variable If    ${endinterval} == ''    ${today}    ${endInterval}

    IF    '${startInterval}' > '${endInterval}'
        Fail    Parameters errors: in the range definition the beginning (${startInterval}) should come before the end (${endInterval})
    END

    Log to console    \n........................................
    
    @{daysToPopulate}=    utilities.Workdays    ${startInterval}    ${endInterval}
    FOR    ${day}    IN    @{daysToPopulate}
        Log Random Ticket Half day    ${day}
        Log Random Ticket Half day    ${day}
    END
