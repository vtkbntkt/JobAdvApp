public class BaseFileService implements IfileService {

    public String saveFile(String fileName, String fileContent, String shareType, String visibility, id relatedEntityId){
        return saveFile(fileName, 
        EncodingUtil.base64Decode(fileContent.substring(fileContent.indexOf(',') + 1, 
        fileContent.length()-1)), 
        shareType, 
        visibility, 
        relatedEntityId);
    }

     public String saveFile(String fileName, Blob fileContent, String shareType, String visibility, id relatedEntityId){
         String contentVersionId;
        try{          
            ContentVersion contentVersion = getContentVersion(fileName, fileContent);
            insert contentVersion;
            Id contentDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:contentVersion.Id].ContentDocumentId;
            ContentDocumentLink contentDocLink = getContentDocLink(contentDocId, shareType, visibility, relatedEntityId);
            insert contentDocLink;
            contentVersionId = contentVersion.id;   
        }
        catch(DmlException dmlExc){
            throw new SaveFileException(dmlExc.getMessage(), dmlExc);
        }
        catch(QueryException queryExc){
            throw new SaveFileException(queryExc.getMessage(), queryExc);
        }
        return contentVersionId;
    }

    private ContentVersion getContentVersion(String fileName, Blob fileContent){
        ContentVersion contentVersion = new ContentVersion();
        contentVersion.versionData = fileContent;
        contentVersion.title = fileName;
        contentVersion.pathOnClient =fileName;
        return contentVersion;       
    }


    private ContentDocumentLink getContentDocLink(Id contentDocId, String shareType, String visibility, id linkedEntityId){
        ContentDocumentLink contentDocLink = new ContentDocumentLink();
        contentDocLink.ContentDocumentId = contentDocId;
        contentDocLink.LinkedEntityId = linkedEntityId;
        contentDocLink.ShareType = shareType; 
        contentDocLink.Visibility = visibility;
        return contentDocLink;
    }

    public void removeFile(Id contentVersionId){
        try{
        ContentDocument contentDoc = 
            [SELECT id FROM ContentDocument WHERE id IN (SELECT ContentDocumentId FROM ContentVersion WHERE id=:contentVersionId)];        
            delete contentDoc;
        }
         catch(DmlException dmlExc){
            throw new ClearFileException(dmlExc.getMessage(), dmlExc);
        }
        catch(QueryException queryExc){
            throw new ClearFileException(queryExc.getMessage(), queryExc);
        }
    }
}
