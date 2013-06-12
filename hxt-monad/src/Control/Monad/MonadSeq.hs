{-# LANGUAGE FlexibleInstances      #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE MultiParamTypeClasses  #-}

-- ----------------------------------------
{- |

   Common features of sequences (lists, trees, ...)

-}
-- ----------------------------------------

module Control.Monad.MonadSeq
where

import           Data.Sequence.Seq
import           Data.Sequence.Sequence

-- ----------------------------------------

infixl 1 >>=*
infixr 1 >=>*

-- | This class enables access to the whole result set of a
-- nondeterministic computation via the @>>=*@ (bind list) operator.
-- @returnS@ puts a whole result set into the nondeterministic monad

class (Monad m) => MonadSeq m where
    returnS :: Seq a -> m a
    (>>=*)  :: m a -> (Seq a -> m b) -> m b

(>=>*) :: (MonadSeq m) => (a -> m b) -> (Seq b -> m c) -> (a -> m c)
f >=>* g = \ x -> f x >>=* g

convFrom :: (MonadSeq m) => Seq a -> m a
convFrom = returnS

fromList :: (MonadSeq m) => [a] -> m a
fromList = returnS . toS

toList :: (MonadSeq m) => m a -> m [a]
toList m = m >>=* return . fromS

{-# INLINE (>=>*)   #-}
{-# INLINE fromList #-}
{-# INLINE toList   #-}

-- ----------------------------------------
