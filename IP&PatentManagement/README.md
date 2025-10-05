# Phase 6: User Interface Development – Salesforce DX Focus

This guide details the **setup, configuration, and development workflow** for Phase 6 of the IP & Patent Management Project, focusing on **Visual Studio Code**, **Salesforce DX**, and **Lightning Web Components (LWC)**.

---

## 🖥️ 1. Environment Setup

### **1.1. Install Visual Studio Code**
- Download and install [Visual Studio Code](https://code.visualstudio.com/).
- Install the recommended extensions for Salesforce development:
    - `Salesforce Extension Pack`
    - `Prettier - Code formatter`

### **1.2. Install Salesforce CLI**
- Install the [Salesforce CLI (SFDX)](https://developer.salesforce.com/tools/sfdxcli).
- Verify the installation by running the following command in your terminal:
    ```bash
    sfdx --version
    ```
- **Note:** Ensure the CLI path is correctly added to your system's environment variables.

### **1.3. Configure VS Code Settings**
1.  Open VS Code Settings (`Ctrl` + `,`).
2.  Navigate to `Extensions` > `Salesforce`.
3.  Enable settings like "Auto-format on save" for a smoother workflow.
4.  Optionally, configure workspace-specific settings (`.vscode/settings.json`) to maintain project consistency.

---

## 🔗 2. Salesforce DX Project Setup

### **2.1. Authenticate to a Salesforce Org**
- Open the VS Code terminal and authorize your development org:
    ```bash
    sfdx auth:web:login -a IPPatentOrg
    ```
- The `-a IPPatentOrg` flag sets a convenient alias for your org.

### **2.2. Create a Salesforce DX Project**
- Generate the project structure with the following command:
    ```bash
    sfdx project:create -n IPPatentManagement
    ```
- This creates the standard SFDX project layout:
    ```text
    IPPatentManagement/
    ├── force-app/
    │   └── main/
    │       └── default/
    │           ├── classes/
    │           └── lwc/
    └── sfdx-project.json
    ```

### **2.3. Retrieve Existing Metadata**
- Pull essential metadata from your org into the local project:
    ```bash
    sfdx force:source:retrieve -m "ApexClass,CustomObject,Flow"
    ```

---

## ⚡ 3. Lightning Web Component (LWC) Development

### **3.1. Create a New LWC**
- Use the CLI to scaffold a new LWC. For example, a `patentTimeline` component:
    ```bash
    sfdx force:lightning:component:create --type lwc -n patentTimeline -d force-app/main/default/lwc
    ```
- This generates the component bundle:
    ```text
    patentTimeline/
    ├── patentTimeline.html
    ├── patentTimeline.js
    ├── patentTimeline.js-meta.xml
    └── patentTimeline.css
    ```

### **3.2. Implement the LWC**
- **HTML (`patentTimeline.html`):** Define the component's structure and UI for patent visualization.
- **JavaScript (`patentTimeline.js`):** Implement the component's logic, fetching data from Salesforce using Wire Adapters or imperative Apex calls.
- **CSS (`patentTimeline.css`):** Apply styles to create a responsive and visually appealing component.

### **3.3. Deploy and Test**
- Push your local changes to the Salesforce org:
    ```bash
    sfdx force:source:push
    ```
- Test the LWC by adding it to a relevant Lightning Page (e.g., the Patent Record Page) using the Lightning App Builder.

---

## 🧩 4. Apex Class Development

### **4.1. Create an Apex Class**
- Create a new Apex class to handle server-side logic:
    ```bash
    sfdx force:apex:class:create -n PatentController -d force-app/main/default/classes
    ```

### **4.2. Implement Apex Logic**
- Write methods to support your LWC. For example, a method to fetch patent records:
    ```apex
    // force-app/main/default/classes/PatentController.cls
    public with sharing class PatentController {
            @AuraEnabled(cacheable=true)
            public static List<Patent__c> getActivePatents() {
                    return [
                            SELECT Id, Name, Filing_Date__c, Expiry_Date__c, Status__c
                            FROM Patent__c
                            WHERE Status__c != 'Expired'
                            ORDER BY Filing_Date__c DESC
                    ];
            }
    }
    ```

### **4.3. Deploy and Test**
- Deploy the Apex class to your org:
    ```bash
    sfdx force:source:push
    ```
- Run associated unit tests to ensure code quality and functionality:
    ```bash
    sfdx force:apex:test:run --result-format human
    ```

---

## ✅ Phase 6 Outcomes

- [x] **VS Code Environment:** Fully configured with Salesforce DX integration.
- [x] **Org Connection:** Successfully connected to a Salesforce org for development.
- [x] **LWC Created:** Developed a `patentTimeline` component for data visualization.
- [x] **Apex Class Developed:** Implemented a `PatentController` for data retrieval.
- [x] **Successful Deployment:** Components and classes deployed and tested on the Patent Record Page.

---

## 📌 Notes
- **Wire Adapters** are preferred for reactive data binding in LWCs.
- **Imperative Apex Calls** are used for complex queries or data manipulation that needs to be explicitly invoked.
- All development is managed within VS Code, enabling version control and a streamlined deployment workflow.
