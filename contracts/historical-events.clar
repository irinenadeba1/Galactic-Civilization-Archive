;; Historical Events Contract

(define-data-var event-count uint u0)

(define-map historical-events
  uint
  {
    civilization-id: uint,
    event-name: (string-ascii 100),
    event-date: uint,
    description: (string-utf8 1000),
    significance: uint,
    verified: bool
  }
)

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_NOT_AUTHORIZED (err u403))
(define-constant ERR_INVALID_EVENT (err u404))

(define-public (record-event
    (civilization-id uint)
    (event-name (string-ascii 100))
    (event-date uint)
    (description (string-utf8 1000))
    (significance uint)
  )
  (let
    (
      (event-id (+ (var-get event-count) u1))
    )
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_NOT_AUTHORIZED)
    (map-set historical-events
      event-id
      {
        civilization-id: civilization-id,
        event-name: event-name,
        event-date: event-date,
        description: description,
        significance: significance,
        verified: false
      }
    )
    (var-set event-count event-id)
    (ok event-id)
  )
)

(define-public (verify-event (event-id uint))
  (let
    (
      (event (unwrap! (map-get? historical-events event-id) ERR_INVALID_EVENT))
    )
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_NOT_AUTHORIZED)
    (ok (map-set historical-events
      event-id
      (merge event { verified: true })
    ))
  )
)

(define-read-only (get-event (event-id uint))
  (map-get? historical-events event-id)
)

(define-read-only (get-event-count)
  (var-get event-count)
)
