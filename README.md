# Mass Reassignment Tool Notes

Frequently, Litify admins need to reassign large amounts of cases from one user to the next. Out-of-the-box Salesforce automation tools can rarely accomplsih this without running into CPU timeout or iteration limits in Flow. Apex, however, can handle these types of request with ease. Mass Reassignment Tool leverages Salesforce's LWC and Apex's batchable interface to present Litify admin's with a friendly user interface.

- **IMPORTANT**: In order for the "and Lookups" functionality to work properly, you will need to add the User lookup fields as Custom Metadata Type records. Every org will have differently lookups they want to update so the custom metadata type holds this information for your specific org. Please also note, that the lookups will only update IF the current user is any of the fields defined in custom metadata.
# Installation Link

Sandbox: https://test.salesforce.com/packaging/installPackage.apexp?p0=04tDS000000AQWh&isdtp=p1


