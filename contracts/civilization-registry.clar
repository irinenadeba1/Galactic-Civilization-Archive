;; Civilization Registry Contract

(define-data-var civilization-count uint u0)

(define-map civilizations
  uint
  {
    name: (string-ascii 100),
    founder: principal,
    home-planet: (string-ascii 100),
    founding-year: uint,
    technology-level: uint,
    population: uint,
    description: (string-utf8 1000)
  }
)

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_NOT_AUTHORIZED (err u403))
(define-constant ERR_INVALID_CIVILIZATION (err u404))

(define-public (register-civilization
    (name (string-ascii 100))
    (home-planet (string-ascii 100))
    (founding-year uint)
    (technology-level uint)
    (population uint)
    (description (string-utf8 1000))
  )
  (let
    (
      (civilization-id (+ (var-get civilization-count) u1))
    )
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_NOT_AUTHORIZED)
    (map-set civilizations
      civilization-id
      {
        name: name,
        founder: tx-sender,
        home-planet: home-planet,
        founding-year: founding-year,
        technology-level: technology-level,
        population: population,
        description: description
      }
    )
    (var-set civilization-count civilization-id)
    (ok civilization-id)
  )
)

(define-public (update-civilization-data (civilization-id uint) (technology-level uint) (population uint))
  (let
    (
      (civilization (unwrap! (map-get? civilizations civilization-id) ERR_INVALID_CIVILIZATION))
    )
    (asserts! (or (is-eq tx-sender CONTRACT_OWNER) (is-eq tx-sender (get founder civilization))) ERR_NOT_AUTHORIZED)
    (ok (map-set civilizations
      civilization-id
      (merge civilization {
        technology-level: technology-level,
        population: population
      })
    ))
  )
)

(define-read-only (get-civilization (civilization-id uint))
  (map-get? civilizations civilization-id)
)

(define-read-only (get-civilization-count)
  (var-get civilization-count)
)
