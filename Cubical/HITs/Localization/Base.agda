{-# OPTIONS --cubical --safe #-}
module Cubical.HITs.Localization.Base where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function
open import Cubical.Foundations.PathSplitEquiv
open isPathSplitEquiv

module _ {ℓα ℓs ℓt} {A : Type ℓα} {S : A → Type ℓs} {T : A → Type ℓt} where

  isLocal : ∀ (F : ∀ α → S α → T α) {ℓ} (X : Type ℓ) → Type _
  isLocal F X = ∀ α → isPathSplitEquiv (λ (g : T α → X) → g ∘ F α)

  data Localize (F : ∀ α → S α → T α) {ℓ} (X : Type ℓ) : Type (ℓ-max ℓ (ℓ-max ℓα (ℓ-max ℓs ℓt))) where
    ∣_∣ : X → Localize F X
    -- (_∘ F α) : (T α → Localize F X) → (S α → Localize F X) is a path-split equivalence ∀ α
    ext   : ∀ α → (S α → Localize F X) → (T α → Localize F X)
    isExt : ∀ α (f : S α → Localize F X) (s : S α) → ext α f (F α s) ≡ f s
    ≡ext   : ∀ α (g h : T α → Localize F X) → ((s : S α) → g (F α s) ≡ h (F α s)) → ((t : T α) → g t ≡ h t)
    ≡isExt : ∀ α g h (p : (s : S α) → g (F α s) ≡ h (F α s)) (s : S α) → ≡ext α g h p (F α s) ≡ p s

  Localize-isLocal : ∀ (F : ∀ α → S α → T α) {ℓ} (X : Type ℓ) → isLocal F (Localize F X)
  fst (sec (Localize-isLocal F X α)) f t   = ext   α f t
  snd (sec (Localize-isLocal F X α)) f i s = isExt α f s i
  fst (secCong (Localize-isLocal F X α) g h) p i t   = ≡ext   α g h (appl p) t i
  snd (secCong (Localize-isLocal F X α) g h) p i j t = ≡isExt α g h (appl p) t i j
