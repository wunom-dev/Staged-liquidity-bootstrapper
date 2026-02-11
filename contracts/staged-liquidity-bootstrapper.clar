;; =====================================================
;; StagedLiquidityBootstrapper
;; Gradual liquidity release for fair token launches
;; =====================================================

;; -----------------------------
;; Data Variables
;; -----------------------------

(define-data-var admin principal tx-sender)
(define-data-var initialized bool false)

;; -----------------------------
;; Data Maps
;; -----------------------------

;; stage-id => stage configuration
(define-map stages
  uint
  {
    unlock-height: uint,
    stx-amount: uint,
    released: bool
  }
)

(define-data-var stage-count uint u0)

;; -----------------------------
;; Errors
;; -----------------------------

(define-constant ERR-NOT-AUTHORIZED u100)
(define-constant ERR-ALREADY-INITIALIZED u101)
(define-constant ERR-NOT-READY u102)
(define-constant ERR-ALREADY-RELEASED u103)
(define-constant ERR-NOT-FOUND u104)

;; -----------------------------
;; Helpers
;; -----------------------------

(define-read-only (is-admin)
  (is-eq tx-sender (var-get admin))
)

;; -----------------------------
;; Initialization
;; -----------------------------

(define-public (add-stage
  (unlock-height uint)
  (stx-amount uint)
)
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    (asserts! (not (var-get initialized)) (err ERR-ALREADY-INITIALIZED))
    (asserts! (> stx-amount u0) (err ERR-NOT-READY))

    (let ((id (var-get stage-count)))
      (map-set stages id {
        unlock-height: unlock-height,
        stx-amount: stx-amount,
        released: false
      })
      (var-set stage-count (+ id u1))
      (ok id)
    )
  )
)

(define-public (finalize-stages)
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    (var-set initialized true)
    (ok true)
  )
)

;; -----------------------------
;; Liquidity Release
;; -----------------------------

(define-public (release-stage (stage-id uint) (recipient principal))
  (begin
    (let ((stage (map-get? stages stage-id)))
      (match stage s
        (begin
          (asserts! (var-get initialized) (err ERR-NOT-READY))
          (asserts! (>= stacks-block-height (get unlock-height s)) (err ERR-NOT-READY))
          (asserts! (not (get released s)) (err ERR-ALREADY-RELEASED))

          ;; update state before transfer
          (map-set stages stage-id {
            unlock-height: (get unlock-height s),
            stx-amount: (get stx-amount s),
            released: true
          })

          (stx-transfer?
            (get stx-amount s)
            (as-contract tx-sender)
            recipient
          )
        )
        (err ERR-NOT-FOUND)
      )
    )
  )
)

;; -----------------------------
;; Read-only Views
;; -----------------------------

(define-read-only (get-stage (stage-id uint))
  (map-get? stages stage-id)
)

(define-read-only (get-stage-count)
  (var-get stage-count)
)
