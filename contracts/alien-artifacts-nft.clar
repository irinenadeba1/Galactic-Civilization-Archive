;; Alien Artifacts NFT Contract

(define-non-fungible-token alien-artifact uint)

(define-data-var last-token-id uint u0)

(define-map token-metadata
  uint
  {
    name: (string-ascii 100),
    civilization-id: uint,
    discovery-date: uint,
    description: (string-utf8 1000),
    rarity: uint,
    image-url: (string-ascii 256)
  }
)

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_NOT_AUTHORIZED (err u403))

(define-public (mint (name (string-ascii 100)) (civilization-id uint) (discovery-date uint) (description (string-utf8 1000)) (rarity uint) (image-url (string-ascii 256)))
  (let
    (
      (token-id (+ (var-get last-token-id) u1))
    )
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_NOT_AUTHORIZED)
    (try! (nft-mint? alien-artifact token-id tx-sender))
    (map-set token-metadata
      token-id
      {
        name: name,
        civilization-id: civilization-id,
        discovery-date: discovery-date,
        description: description,
        rarity: rarity,
        image-url: image-url
      }
    )
    (var-set last-token-id token-id)
    (ok token-id)
  )
)

(define-public (transfer (token-id uint) (recipient principal))
  (nft-transfer? alien-artifact token-id tx-sender recipient)
)

(define-read-only (get-token-metadata (token-id uint))
  (map-get? token-metadata token-id)
)

(define-read-only (get-last-token-id)
  (var-get last-token-id)
)
