/ / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |                                                                                     M a r k e t _ b o o k _ s y n h r o n . m q h   |  
 / / |                                                                                               A l i a k s a n d r   H r y s h y n   |  
 / / |                                                     h t t p s : / / w w w . m q l 5 . c o m / r u / u s e r s / g r e s h n i k 1   |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 # p r o p e r t y   c o p y r i g h t   " A l i a k s a n d r   H r y s h y n "  
 # p r o p e r t y   l i n k             " h t t p s : / / w w w . m q l 5 . c o m / r u / u s e r s / g r e s h n i k 1 "  
  
 / / V i s u a l   p r o p e r t i e s   o f   D e p t h   o f   M a r k e t  
 e n u m   e M D _ p r o p e r t y  
     {  
       m d p _ ,  
       m d p _ p o s _ x , / / L e f t   m a r g i n  
       m d p _ p o s _ y , / / I n d e n t   f r o m   t h e   t o p   e d g e  
       m d p _ m i n i m i z e d _ p o s _ x , / / I n d e n t   f r o m   t h e   l e f t   e d g e   f o r   t h e   m i n i m i z e d   w i n d o w  
       m d p _ m i n i m i z e d _ p o s _ y , / / I n d e n t   f r o m   t o p   e d g e   f o r   m i n i m i z e d   w i n d o w  
       m d p _ s i z e _ x , / / W i d t h  
       m d p _ s i z e _ y , / / H e i g h t  
       m d p _ i s _ a u t o s c r o l l , / / A u t o   s c r o l l   p r i c e s  
       m d p _ i s _ r e a l _ v o l u m e s , / / A r e   r e a l   v o l u m e s   u s e d  
       m d p _ i s _ m i n i m i z e d , / / W h e t h e r   t h e   w i n d o w   i s   m i n i m i z e d  
       m d p _ c o l o r _ h i s t o r y _ b a c k , / / H i s t o r y   b a c k g r o u n d   c o l o r  
       m d p _ c o l o r _ h i s t o r y _ b i d , / / H i s t o r y   b i d   p r i c e   c o l o r  
       m d p _ c o l o r _ h i s t o r y _ a s k , / / H i s t o r y   a s k   p r i c e   c o l o r  
       m d p _ c o l o r _ b a c k , / / D e p t h   o f   M a r k e t   b a c k g r o u n d   c o l o r  
       m d p _ c o l o r _ v o l u m e , / / V o l u m e   c o l o r  
       m d p _ c o l o r _ v o l u m e _ b a c k , / / V o l u m e   b a c k g r o u n d   c o l o r  
       m d p _ c o l o r _ v o l u m e _ b u y , / / C o l o r   o f   t h e   b u y   p r i c e  
       m d p _ c o l o r _ v o l u m e _ s e l l , / / S e l l   p r i c e   c o l o r  
       m d p _ c o l o r _ v o l u m e _ b u y _ m a r k e t , / / C o l o r   o f   b u y   p r i c e   b y   m a r k e t  
       m d p _ c o l o r _ v o l u m e _ s e l l _ m a r k e t , / / C o l o r   o f   s e l l   p r i c e   b y   m a r k e t  
       m d p _ c o l o r _ p r i c e , / / P r i c e   c o l o r  
     } ;  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |                                                                                                                                     |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 t y p e d e f   v o i d   ( * t S y _ O n B o o k E v e n t ) (  
       c o n s t   s t r i n g &   s y m b o l , / / S y m b o l  
       c o n s t   s t r i n g &   s e r v e r _ n a m e / / S e r v e r   n a m e  
 ) ;  
 # i m p o r t   " G r e s h n i k \ \ M a r k e t \ \ M a r k e t _ b o o k _ s y n h r o n _ l i b . e x 5 "  
 / / E n a b l e   c o l l e c t i o n   o r   u s e   o f   d a t a   t o   s y n c h r o n i z e   e v e n t s   O n B o o k E v e n t , O n T i c k  
 / / E v e r y t h i n g   t h a t   a f f e c t s   t h e   O n T i c k   e v e n t s   i n   t h e   t e s t e r   m u s t   b e   e x a c t l y   t h e   s a m e   w h e n   s a v i n g   a n d   u s i n g   d a t a  
 / / U s u a l l y   d o n e   i n   O n I n i t  
 / / w r i t e _ r e a d _ e v e n t s = t r u e   w i l l   c o l l e c t   i n f o r m a t i o n   a b o u t   t h e   e v e n t s   O n T i c k , O n B o o k E v e n t   a n d   w h e n   y o u   c a l l   S a v e _ e v e n t s   w i l l   b e   s a v e d  
 / / w r i t e _ r e a d _ e v e n t s = f a l s e   t h e   p r e v i o u s l y   s a v e d   e v e n t s   a r e   l o a d e d   i n t o   t h e   f i l e   f o r   f u r t h e r   u s e  
 b o o l   c M B S _ W r i t e _ r e a d _ e v e n t s (  
       b o o l   w r i t e _ r e a d _ e v e n t s = f a l s e , / / t r u e = s a v e   f a l s e = r e a d  
       s t r i n g   f i l e _ n a m e = N U L L / / S a v e   f i l e .   N U L L   =   M a r k e t _ b o o k _ d a t a \ T m p \ < C u r r e n t   s e r v e r   n a m e > < I n s t r u m e n t > _ < T e s t   s t a r t   d a t e > . b i n  
 ) ; / / R e t u r n s   t h e   s u c c e s s   o f   t h e   o p e r a t i o n  
  
 / / S a v e   e v e n t s   t o   f i l e  
 / / U s u a l l y   d o n e   i n   O n D e i n i t  
 / / R u n   b e f o r e   u n s u b s c r i b i n g   f r o m   O n B o o k E v e n t   e v e n t s  
 b o o l   c M B S _ S a v e _ e v e n t s (  
 ) ; / / R e t u r n s   t h e   s u c c e s s   o f   t h e   o p e r a t i o n  
  
 / / S e t   e v e n t   h a n d l e r   O n B o o k E v e n t  
 v o i d   c M B S _ S e t _ O n B o o k E v e n t _ h a n d l e r (  
       t S y _ O n B o o k E v e n t   o n b o o k e v e n t _ h a n d l e r  
 ) ;  
  
 / / P l a c e   a t   t h e   v e r y   e n d   o f   O n T i c k  
 v o i d   c M B S _ S y _ O n T i c k (  
 ) ;  
  
 / / R e p l a c i n g   M a r k e t B o o k A d d  
 / / M a x i m u m   7   i n s t r u m e n t s  
 b o o l   c M B S _ S y _ M a r k e t B o o k A d d (  
       c o n s t   s t r i n g   s y m b o l _ n a m e , / / I n s t r u m e n t  
       s t r i n g   s e r v e r _ n a m e = N U L L , / / S e r v e r   n a m e .   N U L L = c u r r e n t   s e r v e r  
       i n t   t i m e _ s h i f t = 0 / / T i m e   o f f s e t   i n   m s .   T h e   e v e n t   w i l l   o c c u r   a t   t h e   s p e c i f i e d   t i m e   l a t e r  
 ) ;  
  
 / / R e p l a c i n g   M a r k e t B o o k R e l e a s e  
 b o o l   c M B S _ S y _ M a r k e t B o o k R e l e a s e (  
       c o n s t   s t r i n g   s y m b o l _ n a m e , / / I n s t r u m e n t  
       s t r i n g   s e r v e r _ n a m e = N U L L / / S e r v e r   n a m e .   N U L L = c u r r e n t   s e r v e r  
 ) ;  
  
 / / R e p l a c i n g   M a r k e t B o o k G e t  
 b o o l   c M B S _ S y _ M a r k e t B o o k G e t (  
       c o n s t   s t r i n g   s y m b o l , / / T o o l  
       M q l B o o k I n f o &   b o o k [ ] , / / R e c e i v e d   d a t a  
       s t r i n g   s e r v e r _ n a m e = N U L L / / S e r v e r   n a m e .   N U L L = c u r r e n t   s e r v e r  
 ) ;  
  
 / / E n a b l e / d i s a b l e   e x t e r n a l   c o n t r o l  
 / / O n l y   f o r   t e s t e r   w i t h   v i s u a l i z a t i o n  
 b o o l   c M B S _ S e t _ e x t e r n a l _ c o n t r o l (  
       b o o l   i s _ c o n t r o l  
 ) ; / / R e t u r n s   t h e   s u c c e s s   o f   t h e   o p e r a t i o n  
  
 / / R e a l - t i m e   s i m u l a t i o n   w i t h   a c c e l e r a t i o n / d e c e l e r a t i o n   m u l t i p l i e r  
 / / < = 0   d o   n o t   u s e  
 / / > 0   a n d   < 1   a c c e l e r a t i o n  
 / / > 1   s l o w d o w n  
 / / = 1   r e a l   t i m e  
 v o i d   c M B S _ S e t _ v i s u a l _ t i m e _ r e a l _ m u l (  
       d o u b l e   t i m e _ r e a l _ m u l = 1 . 0  
 ) ;  
  
 / / R e t u r n s   t h e   n u m b e r   o f   s i g n i f i c a n t   d i g i t s   a f t e r   t h e   d e c i m a l   p o i n t   f o r   i n s t r u m e n t   p r i c e s  
 / / F o r   a   t h i r d - p a r t y   i n s t r u m e n t ,   t h e   o r d e r   b o o k   d a t a   m u s t   f i r s t   b e   l o a d e d   ( S y _ M a r k e t B o o k A d d )  
 i n t   c M B S _ G e t _ s y m b o l _ d i g i t s (  
       c o n s t   s t r i n g   s y m b o l _ n a m e , / / I n s t r u m e n t  
       s t r i n g   s e r v e r _ n a m e = N U L L / / S e r v e r   n a m e .   N U L L = c u r r e n t   s e r v e r  
 ) ; / / O n   e r r o r   r e t u r n s   - 1  
  
 / / R e t u r n s   t h e   p o i n t   s i z e   f o r   t h e   i n s t r u m e n t  
 / / F o r   a   t h i r d - p a r t y   i n s t r u m e n t ,   t h e   o r d e r   b o o k   d a t a   m u s t   f i r s t   b e   l o a d e d   ( S y _ M a r k e t B o o k A d d )  
 d o u b l e   c M B S _ G e t _ s y m b o l _ p o i n t (  
       c o n s t   s t r i n g   s y m b o l _ n a m e , / / I n s t r u m e n t  
       s t r i n g   s e r v e r _ n a m e = N U L L / / S e r v e r   n a m e .   N U L L = c u r r e n t   s e r v e r  
 ) ; / / O n   e r r o r   r e t u r n s   - 1  
  
 / / R e t u r n s   t h e   m i n i m u m   p r i c e   c h a n g e   f o r   t h e   i n s t r u m e n t  
 / / F o r   a   t h i r d - p a r t y   i n s t r u m e n t ,   t h e   o r d e r   b o o k   d a t a   m u s t   f i r s t   b e   l o a d e d   ( S y _ M a r k e t B o o k A d d )  
 d o u b l e   c M B S _ G e t _ s y m b o l _ t i c k _ s i z e (  
       c o n s t   s t r i n g   s y m b o l _ n a m e , / / I n s t r u m e n t  
       s t r i n g   s e r v e r _ n a m e = N U L L / / S e r v e r   n a m e .   N U L L = c u r r e n t   s e r v e r  
 ) ; / / O n   e r r o r   r e t u r n s   - 1  
  
 / / O p e n   i n t e r e s t  
 d o u b l e   c M B S _ G e t _ s y m b o l _ i n t e r e s t (  
       c o n s t   s t r i n g   s y m b o l _ n a m e , / / I n s t r u m e n t  
       s t r i n g   s e r v e r _ n a m e = N U L L / / S e r v e r   n a m e .   N U L L = c u r r e n t   s e r v e r  
 ) ; / / O n   e r r o r   r e t u r n s   - 1  
  
 / / B u y   v o l u m e  
 d o u b l e   c M B S _ G e t _ s y m b o l _ b u y _ v o l u m e (  
       c o n s t   s t r i n g   s y m b o l _ n a m e , / / I n s t r u m e n t  
       s t r i n g   s e r v e r _ n a m e = N U L L / / S e r v e r   n a m e .   N U L L = c u r r e n t   s e r v e r  
 ) ; / / O n   e r r o r   r e t u r n s   - 1  
  
 / / S e l l   v o l u m e  
 d o u b l e   c M B S _ G e t _ s y m b o l _ s e l l _ v o l u m e (  
       c o n s t   s t r i n g   s y m b o l _ n a m e , / / I n s t r u m e n t  
       s t r i n g   s e r v e r _ n a m e = N U L L / / S e r v e r   n a m e .   N U L L = c u r r e n t   s e r v e r  
 ) ; / / O n   e r r o r   r e t u r n s   - 1  
  
 / / V i s u a l i z a t i o n   o f   D e p t h   o f   M a r k e t  
 b o o l   c M B S _ S e t _ v i s u a l (  
       c o n s t   s t r i n g   s y m b o l _ n a m e ,  
       b o o l   i s _ v i s u a l , / / T u r n   o n / o f f   v i s u a l i z a t i o n  
       s t r i n g   s e r v e r _ n a m e = N U L L / / S e r v e r   n a m e .   N U L L = c u r r e n t   s e r v e r  
 ) ; / / R e t u r n s   t h e   s u c c e s s   o f   t h e   o p e r a t i o n  
  
 / / C h a n g i n g   t h e   m a i n   v i s u a l   p r o p e r t i e s   o f   t h e   D e p t h   o f   M a r k e t  
 b o o l   c M B S _ S e t _ v i s u a l _ p r o p e r t y (  
       c o n s t   s t r i n g   s y m b o l _ n a m e , / / S y m b o l  
       e M D _ p r o p e r t y   p r o p e r t y , / / M o d i f i a b l e   p r o p e r t y  
       l o n g   p r o p e r t y _ v a l u e , / / P r o p e r t y   v a l u e  
       s t r i n g   s e r v e r _ n a m e = N U L L / / S e r v e r   n a m e .   N U L L = c u r r e n t   s e r v e r  
 ) ; / / R e t u r n s   t h e   s u c c e s s   o f   t h e   o p e r a t i o n  
  
 / / G e t t i n g   t h e   m a i n   v i s u a l   p r o p e r t y   o f   t h e   D e p t h   o f   M a r k e t  
 l o n g   c M B S _ G e t _ v i s u a l _ p r o p e r t y (  
       c o n s t   s t r i n g   s y m b o l _ n a m e , / / S y m b o l  
       e M D _ p r o p e r t y   p r o p e r t y , / / P r o p e r t y  
       s t r i n g   s e r v e r _ n a m e = N U L L / / S e r v e r   n a m e .   N U L L = c u r r e n t   s e r v e r  
 ) ; / / O n   e r r o r   r e t u r n s   L O N G _ M A X  
  
 / / P a c k i n g / u n p a c k i n g   d a t a  
 / / I n i t i a l   l o a d i n g   o f   d e c o m p r e s s e d   d a t a   i s   n o t i c e a b l y   f a s t e r  
 b o o l   c M B S _ Z i p (  
       b o o l   z i p _ c o m p r e s s i o n , / / t r u e = p a c k   f a l s e = u n p a c k  
       s t r i n g   i n p u t _ f i l e _ n a m e , / / O r i g i n a l   f i l e n a m e  
       s t r i n g   o u t p u t _ f i l e _ n a m e = N U L L / / N e w   f i l e   n a m e . N U L L = O r i g i n a l   f i l e   i s   r e p l a c e d  
 ) ; / / R e t u r n s   t h e   s u c c e s s   o f   t h e   o p e r a t i o n  
  
 / / P a c k i n g / u n p a c k i n g   d a t a  
 / / I n i t i a l   l o a d i n g   o f   d e c o m p r e s s e d   d a t a   i s   n o t i c e a b l y   f a s t e r  
 b o o l   Z i p (  
       b o o l   z i p _ c o m p r e s s i o n , / / t r u e = p a c k   f a l s e = u n p a c k  
       s t r i n g   & i n p u t _ f i l e _ n a m e s [ ] , / / O r i g i n a l   f i l e n a m e s  
       s t r i n g   & o u t p u t _ f i l e _ n a m e s [ ] / / N a m e s   o f   n e w   f i l e s .   F o r   N U L L   n a m e s ,   t h e   o r i g i n a l   n a m e   w i l l   b e   t a k e n .   T h e   s i z e   o f   t h e   a r r a y   c a n   b e   l e s s   t h a n   i n p u t _ f i l e _ n a m e s  
 ) ; / / R e t u r n s   t h e   s u c c e s s   o f   t h e   o p e r a t i o n  
 # i m p o r t  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 