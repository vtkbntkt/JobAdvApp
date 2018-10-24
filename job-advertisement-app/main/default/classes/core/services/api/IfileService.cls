public interface IfileService {   
    String saveFile(String fileName, String fileContent, String shareType, String visibility, id relatedEntityId);
    String saveFile(String fileName, Blob fileContent, String shareType, String visibility, id relatedEntityId);
    void removeFile(Id fileId);
}
