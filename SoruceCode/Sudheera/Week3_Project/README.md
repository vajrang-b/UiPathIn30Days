### Documentation is included in the Documentation folder ###

[REFrameWork Documentation](https://github.com/UiPath/ReFrameWork/blob/master/Documentation/REFramework%20documentation.pdf)

### REFrameWork Template ###
**Robotic Enterprise Framework**

* Built on top of *Transactional Business Process* template
* Uses *State Machine* layout for the phases of automation project
* Offers high level logging, exception handling and recovery
* Keeps external settings in *Config.xlsx* file and Orchestrator assets
* Pulls credentials from Orchestrator assets and *Windows Credential Manager*
* Gets transaction data from Orchestrator queue and updates back status
* Takes screenshots in case of system exceptions


### How It Works ###

1. **INITIALIZE PROCESS**
 + ./Framework/*InitiAllSettings* - Load configuration data from Config.xlsx file and from assets
 + ./Framework/*GetAppCredential* - Retrieve credentials from Orchestrator assets or local Windows Credential Manager
 + ./Framework/*InitiAllApplications* - Open and login to applications used throughout the process

2. **GET TRANSACTION DATA**
 + ./Framework/*GetTransactionData* - Fetches transactions from an Orchestrator queue defined by Config("OrchestratorQueueName") or any other configured data source

3. **PROCESS TRANSACTION**
 + *Process* - Process trasaction and invoke other workflows related to the process being automated 
 + ./Framework/*SetTransactionStatus* - Updates the status of the processed transaction (Orchestrator transactions by default): Success, Business Rule Exception or System Exception

4. **END PROCESS**
 + ./Framework/*CloseAllApplications* - Logs out and closes applications used throughout the process


### For New Project ###

1. Check the Config.xlsx file and add/customize any required fields and values
2. Implement InitiAllApplications.xaml and CloseAllApplicatoins.xaml workflows, linking them in the Config.xlsx fields
3. Implement GetTransactionData.xaml and SetTransactionStatus.xaml according to the transaction type being used (Orchestrator queues by default)
4. Implement Process.xaml workflow and invoke other workflows related to the process being automated


### Init

    ### First Run
    1. Read config
        In: 
            excelFilePath
            Settings,Constants
        Out: 
            Config

    2.Open SupplyChainManagement
        In:
            Url fo SCM Config("SCM_URL")

        Out:
            list or datatable of PoNumbers
    
    3.For each activity
        (Activity)Add Queue Item
            Input: PoIndex
            Input: PoNumber
        Output: Not required

    4.(Activity) Read Assignments excel Sheet
        in: FilePath Config("AssignmentFielPath")
        in: sheetname to read Config("AssignmentSheetName)

   ### Init App Applications
    1. Login to Procurement managemen
        in:
            PM_URL Config("PM_URL")
            in_PM_AssetName Config(PM_Credentials)
            
        out:     Nothing

        *** Open Browser(in_PM_URL)
            Get Credential Asset(in_PM_AssetName)
                Out: UserName 
                out: SecurePassword

            Type Into(Username)
            Secure Type into(SSecure Password)
            Click sign in 

                element exists( check for element after login)
                    or
                on Element Apper (check for element after login)
                    Log( Login Successful )

### Get Transaction Data

    1. Get a transaction Item 
        out: 
            out_TransactionItem(type: QueueItem) - TransactionItem


### Process

   1. ### Find PoNumber Details
        in:
            PoNumber -- TransactionItem.SpecificContent("PoNumber")
        out:
            out_ShipDate -- strShipDate
            out_OrderToken -- strOrderToken
            out_State -- strState

    2. ### Search AgentName
        in:   
            in_strState

        out: 

            out_Agentname -- strAgentName   

    3. ### Add Values to SCM

        in:
            in_PoIndex - 1,2,3,

                Use PoIndex and find dynamic Variable
                <webctrl id='PONumber{{intPoindex}}' tag='INPUT' />

                or

                for
                    list.IndexOf(Item) - indexNumber of poNumber
            in_ShipDate -- strShipDate
            in_OrderToken -- strOrderToken
            in_State -- strState -- dr.rows(0)(Key)


### End Process

    1. Submit
    2. take Screenshot
    3. Sendmail


