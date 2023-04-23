import SwiftUI
import Alamofire
import NotionSwift

class WhisperNotionManager: ObservableObject {
    @Published var notionClient: NotionClient

    init() {
        print(getInternalIntegrationToken()!)
        let notion = NotionClient(accessKeyProvider: StringAccessKeyProvider(accessKey: getInternalIntegrationToken()!))
        notionClient = notion
    }

    func transcribeAudio(audioUrl: URL, completion: @escaping (String?) -> Void) {
        let openAIUrl = "https://api.openai.com/v1/audio/transcriptions"
        let apiKey = "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"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "multipart/form-data"
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(audioUrl, withName: "file")
            multipartFormData.append("whisper-1".data(using: .utf8)!, withName: "model")
        }, to: openAIUrl, headers: headers)
        .responseDecodable(of: WhisperResponse.self) { response in
            switch response.result {
            case .success(let whisperResponse):
                print(whisperResponse.text!)
                completion(whisperResponse.text)
            case .failure(let error):
                print("Error decoding response: \(error)")
                completion(nil)
            }
        }
    }

    func addToNotion(text: String) {
        var trimmedText = text
        let periodCharacterSet = CharacterSet(charactersIn: ".")
        trimmedText = trimmedText.trimmingCharacters(in: periodCharacterSet)
                
        if (UserDefaults.standard.bool(forKey: "addToDatabase")) {
            let databaseId = Database.Identifier(getDatabaseId()!)

            let request = PageCreateRequest(
                parent: .database(databaseId),
                properties: [
                    "title": .init(
                        type: .title([
                            .init(string: trimmedText)
                        ])
                    )
                ]
            )

            notionClient.pageCreate(request: request) {
                print($0)
            }
        } else {
            // ebd556b1-c267-401c-817a-aa0efe8eb6c7
            let pageId = Block.Identifier(getPageId()!)
            let blocks: [WriteBlock] = [
                .toDo([RichText(string: trimmedText)])
            ]
            notionClient.blockAppend(blockId: pageId, children: blocks) {
                print($0)
            }
        }
    }
}

func getInternalIntegrationToken() -> String? {
    return UserDefaults.standard.string(forKey: "internalIntegrationToken")
}

func getPageId() -> String? {
    return UserDefaults.standard.string(forKey: "pageId")
}

func getDatabaseId() -> String? {
    return UserDefaults.standard.string(forKey: "databaseId")
}

struct WhisperResponse: Decodable {
    let text: String?
}
