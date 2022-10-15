//
//  ViewController.swift
//  LnkrTask
//
//  Created by Refa3y on 13/10/2022.
//

import UIKit
import CoreNFC

class ViewController: UIViewController, NFCNDEFReaderSessionDelegate {

    @IBOutlet weak var tnfLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var payLoadLengthLbl: UILabel!
    @IBOutlet weak var payloadContentLbl: UILabel!
    
    var session: NFCNDEFReaderSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func beginScanBtnTapped(_ sender: UIButton) {
        session = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue.main, invalidateAfterFirstRead: true)
        session?.alertMessage = "Hold your iPhone near the Tag to learn more about it."
        session?.begin()
    }
    
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        self.session?.alertMessage = "Your Tag successfully read"
        
        let message = messages[0] //first NDEF message
        let record = message.records[0] //first record

        tnfLbl.text = getTNF_Text(TNF: record.typeNameFormat.rawValue)
        typeLbl.text = String(data: record.type , encoding: .utf8) ?? ""
        payLoadLengthLbl.text = "\(record.payload.count) bytes"
        payloadContentLbl.text = String(data: record.payload , encoding: .utf8) ?? ""

    }

    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print(error.localizedDescription)
    }
    
    private func getTNF_Text(TNF: UInt8) -> String {
        switch TNF {
        case 0:
           return "Empty"
        case 1:
            return "NFC WellKnown"
        case 2:
            return "Media"
        case 3:
            return "Absolute URI"
        case 4:
            return "NFC External"
        case 5:
            return "Unknown"
        case 6:
            return "unchanged"
        default:
            return "Not assigned"
        }
    }
}
