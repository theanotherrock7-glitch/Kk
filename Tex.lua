local a a={cache={},load=function(b)if not a.cache[b]then a.cache[b]={c=a[b]()}end return a.cache[b].c end}do function a
.a()local b={cache={}}do do local function c()return nil end function b.a()local d=b.cache.a if not d then d={c=c()}b.
cache.a=d end return d.c end end do local function c()local d,e=b.a(),table.unpack local function f(g,...)local h={...}
return function(...)g(...,e(h))return end end return table.freeze{createCall=f}end function b.b()local d=b.cache.b if
not d then d={c=c()}b.cache.b=d end return d.c end end do local function c()local d,e,f=b.b(),b.a(),{}local function g(h
,...)local i,j=h.event,h.callback local k=d.createCall(j,...)local l,m=i:Connect(k),#f+1 f[m]=l local function n()l:
Disconnect()f[m]=nil end return{disconnect=n}end local function h()for i,j in f do j:Disconnect()f[i]=nil end end return
{connectEvent=g,terminateEvents=h}end function b.c()local d=b.cache.c if not d then d={c=c()}b.cache.c=d end return d.c
end end do local function c()local d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s=true,6.781684027777778E-8,1E-4,math.rad(0.01),math.
rad(0.1),1e-5,game:GetService'RunService',math.pi,math.exp,math.sin,math.cos,math.min,math.max,math.sqrt,math.atan2,math
.round local function t(u)local v=0 for w,x in u do v+=x^2 end return v end local function u(v,w)local x=0 for y,z in v
do x+=(w[y]-z)^2 end return x end local v={}do v.__index=v function v.new(w,x,y,z,A)local B=A.toIntermediate(y)return
setmetatable({d=w,f=x,g=B,p=B,v=table.create(#B,0),typedat=A,rawGoal=z},v)end function v.setGoal(w,x)w.rawGoal=x w.g=w.
typedat.toIntermediate(x)end function v.setDampingRatio(w,x)w.d=x end function v.setFrequency(w,x)w.f=x end function v.
canSleep(w)if t(w.v)>f then return false end if u(w.p,w.g)>e then return false end return true end function v.step(w,x)
local y,z,A,B,C=w.d,w.f*(2*k),w.g,w.p,w.v if y==1 then local D=l(-z*x)local E=x*D local F,G,H=D+E*z,D-E*z,E*z*z for I=1,
#B do local J=B[I]-A[I]B[I]=J*F+C[I]*E+A[I]C[I]=C[I]*G-J*H end elseif y<1 then local D,E=l(-y*z*x),q(1-y*y)local F,G,H=
n(x*z*E),(m(x*z*E))if E>i then H=G/E else local I=x*z H=I+((I*I)*(E*E)*(E*E)/20-E*E)*(I*I*I)/6 end local I if z*E>i then
I=G/(z*E)else local J=z*E I=x+((x*x)*(J*J)*(J*J)/20-J*J)*(x*x*x)/6 end for J=1,#B do local K=B[J]-A[J]B[J]=(K*(F+H*y)+C[
J]*I)*D+A[J]C[J]=(C[J]*(F-H*y)-K*(H*z))*D end else local D=q(y*y-1)local E,F=-z*(y+D),-z*(y-D)local G,H=l(E*x),l(F*x)for
I=1,#B do local J=B[I]-A[I]local K=(C[I]-J*E)/(2*z*D)local L=G*(J-K)B[I]=L+K*H+A[I]C[I]=L*E+K*H*F end end return w.
typedat.fromIntermediate(w.p)end end local w={}do w.__index=w function w.new(x,y,z,A)return setmetatable({d=x,f=y,g=A:
Orthonormalize(),p=z:Orthonormalize(),v=Vector3.zero},w)end function w.setGoal(x,y)x.g=y:Orthonormalize()end function w.
setDampingRatio(x,y)x.d=y end function w.setFrequency(x,y)x.f=y end local function x(y,z)return y.X*z.X+y.Y*z.Y+y.Z*z.Z
end local function y(z,A)local B,C,D=x(z.XVector,A.XVector),x(z.YVector,A.YVector),x(z.ZVector,A.ZVector)local E=B+C+D
return E>1+2*n(g)end local function z(A,B)local C,D,E=x(A.XVector,B.XVector),x(A.YVector,B.YVector),x(A.ZVector,B.
ZVector)local F=C+D+E-1 return r(q(p(0,1-F*F*0.25)),F*0.5)end local function A(B,C)local D,E,F,G,H=n(C),m(C),B.X,B.Y,B.Z
local I,J,K=F*G*(1-D),G*H*(1-D),H*F*(1-D)local L,M,N=Vector3.new(F*F*(1-D)+D,I+H*E,K-G*E),Vector3.new(I-H*E,G*G*(1-D)+D,
J+F*E),Vector3.new(K+G*E,J-F*E,H*H*(1-D)+D)return CFrame.fromMatrix(Vector3.zero,L,M,N):Orthonormalize()end
local function B(C,D)local E,F=CFrame.identity,C.Magnitude if F>1e-6 then E=A(C.Unit,F)end return E*D end local function
C(D,E)local F,G=(D*E:Inverse()):ToAxisAngle(),z(D,E)return F.Unit*G end function w.canSleep(D)local E,F=y(D.p,D.g),D.v.
Magnitude<h return E and F end function w.step(D,E)local F,G,H,I,J=D.d,D.f*(2*k),D.g,D.p,D.v local K,L,M,N=C(I,H),(l(-F*
G*E))if F==1 then M=B((K*(1+G*E)+J*E)*L,H)N=(J*(1-E*G)-K*(E*G*G))*L elseif F<1 then local O=q(1-F*F)local P,Q=n(E*G*O),
m(E*G*O)local R,S=Q/(G*O),Q/O M=B((K*(P+S*F)+J*R)*L,H)N=(J*(P-S*F)-K*(S*G))*L else local O=q(F*F-1)local P,Q=-G*(F+O),-G
*(F-O)local R=(J-K*P)/(2*G*O)local S=K-R local T,U=S*l(P*E),R*l(Q*E)M=B(T+U,H)N=T*P+U*Q end D.p=M D.v=N return M end end
local x,y={springType=v.new,toIntermediate=function(x)return{x.X,x.Y,x.Z}end,fromIntermediate=function(x)return Vector3.
new(x[1],x[2],x[3])end},{}do y.__index=y function y.new(z,A,B,C,D)return setmetatable({rawGoal=C,_position=v.new(z,A,B.
Position,C.Position,x),_rotation=w.new(z,A,B.Rotation,C.Rotation)},y)end function y:setGoal(z)self.rawGoal=z self.
_position:setGoal(z.Position)self._rotation:setGoal(z.Rotation)end function y:setDampingRatio(z)self._position.d=z self.
_rotation.d=z end function y:setFrequency(z)self._position.f=z self._rotation.f=z end function y:canSleep()return self.
_position:canSleep()and self._rotation:canSleep()end function y:step(z)local A,B=self._position:step(z),self._rotation:
step(z)return B+A end end local z,A do local function B(C)return C<0.0404482362771076 and C/12.92 or 0.87941546140213*(C
+0.055)^2.4 end local function C(D)return D<3.1306684424999998e-3 and 12.92*D or 1.055*D^(0.4166666666666667)-0.055 end
function z(D)local E,F,G=D.R,D.G,D.B E=B(E)F=B(F)G=B(G)local H,I,J=0.9257063972951867*E-0.8333736323779866*F-
0.09209820666085898*G,0.2125862307855956*E+0.7151703037034108*F+0.0722004986433362*G,3.6590806972265884*E+
11.442689580057424*F+4.114991502426484*G local K,L,M=I>0.008856451679035631 and 116*I^(0.3333333333333333)-16 or
903.296296296296*I if J>1e-14 then L=K*H/J M=K*(9*I/J-0.46832)else L=-0.19783*K M=-0.46832*K end return{K,L,M}end
function A(D)local E=D[1]if E<0.0197955 then return Color3.new(0,0,0)end local F,G,H=D[2]/E+0.19783,D[3]/E+0.46832,(E+16
)/116 H=H>0.20689655172413793 and H*H*H or 0.12841854934601665*H-0.01771290335807126 local I,J=H*F/G,H*((3-0.75*F)/G-5)
local K,L,M=7.2914074*I-1.537208*H-0.4986286*J,-2.180094*I+1.8757561*H+0.0415175*J,0.1253477*I-0.2040211*H+1.0569959*J
if K<0 and K<L and K<M then K,L,M=0,L-K,M-K elseif L<0 and L<M then K,L,M=K-L,0,M-L elseif M<0 then K,L,M=K-M,L-M,0 end
return Color3.new(o(C(K),1),o(C(L),1),o(C(M),1))end end local B,C={boolean={springType=v.new,toIntermediate=function(B)
return{B and 1 or 0}end,fromIntermediate=function(B)return B[1]>=0.5 end},number={springType=v.new,toIntermediate=
function(B)return{B}end,fromIntermediate=function(B)return B[1]end},NumberRange={springType=v.new,toIntermediate=
function(B)return{B.Min,B.Max}end,fromIntermediate=function(B)return NumberRange.new(B[1],B[2])end},UDim={springType=v.
new,toIntermediate=function(B)return{B.Scale,B.Offset}end,fromIntermediate=function(B)return UDim.new(B[1],s(B[2]))end},
UDim2={springType=v.new,toIntermediate=function(B)local C,D=B.X,B.Y return{C.Scale,C.Offset,D.Scale,D.Offset}end,
fromIntermediate=function(B)return UDim2.new(B[1],s(B[2]),B[3],s(B[4]))end},Vector2={springType=v.new,toIntermediate=
function(B)return{B.X,B.Y}end,fromIntermediate=function(B)return Vector2.new(B[1],B[2])end},Vector3=x,Color3={springType
=v.new,toIntermediate=z,fromIntermediate=A},ColorSequence={springType=v.new,toIntermediate=function(B)local C=B.
Keypoints local D,E=z(C[1].Value),z(C[#C].Value)return{D[1],D[2],D[3],E[1],E[2],E[3]}end,fromIntermediate=function(B)
return ColorSequence.new(A{B[1],B[2],B[3]},A{B[4],B[5],B[6]})end},CFrame={springType=y.new,toIntermediate=error,
fromIntermediate=error}},{Pivot={class='PVInstance',get=function(B)return B:GetPivot()end,set=function(B,C)B:PivotTo(C)
end},Scale={class='Model',get=function(B)return B:GetScale()end,set=function(B,C)local D,E=1.4020000000000001e-45,
16777216 C=math.clamp(C,D,E)B:ScaleTo(C)end}}local function D(E,F)local G=C[F]if G and E:IsA(G.class)then return G.get(E
)else return(E)[F]end end local function E(F,G,H)local I=C[G]if I and F:IsA(I.class)then I.set(F,H)else(F)[G]=H end end
local F,G,H={},{},{}local function I(J,K)for L,M in J do for N,O in M do if O:canSleep()then M[N]=nil E(L,N,O.rawGoal)
else E(L,N,O:step(K))end end if not next(M)then J[L]=nil local N=H[L]if N then H[L]=nil for O,P in N do task.spawn(P)end
end end end end j.PreSimulation:Connect(function(J)I(F,J)end)j.PostSimulation:Connect(function(J)I(G,J)end)
local function J(K,L,M,N)if not M:find(typeof(N))then error(string.format('bad argument #%s to %s (%s expected, got %s)'
,tostring(K),tostring(L),tostring(M),tostring(typeof(N))),3)end end local K={}function K.target(L,M,N,O)if d then J(1,
'spr.target','Instance',L)J(2,'spr.target','number',M)J(3,'spr.target','number',N)J(4,'spr.target','table',O)end if M~=M
or M<0 then error(('expected damping ratio >= 0; got %.2f'):format(M),2)end if N~=N or N<0 then error((
'expected undamped frequency >= 0; got %.2f'):format(N),2)end local P if L:IsA'Camera'then P=G else P=F end local Q=P[L]
if not Q then Q={}P[L]=Q end for R,S in O do local T=D(L,R)if d and typeof(S)~=typeof(T)then error(string.format(
'bad property %s to spr.target (%s expected, got %s)',tostring(R),tostring(typeof(T)),tostring(typeof(S))),2)end if N==
math.huge then E(L,R,S)Q[R]=nil continue end local U=Q[R]if not U then local V=B[typeof(S)]if not V then error(
'unsupported type: '..typeof(S),2)end U=V.springType(M,N,T,S,V)Q[R]=U end U:setGoal(S)U:setDampingRatio(M)U:
setFrequency(N)end if not next(Q)then P[L]=nil end end function K.stop(L,M)if d then J(1,'spr.stop','Instance',L)J(2,
'spr.stop','string|nil',M)end if M then local N=F[L]or G[L]if N then N[M]=nil end else F[L]=nil G[L]=nil end end
function K.completed(L,M)if d then J(1,'spr.completed','Instance',L)J(2,'spr.completed','function',M)end local N=H[L]if
N then table.insert(N,M)else H[L]={M}end end return table.freeze(K)end function b.d()local d=b.cache.d if not d then d={
c=c()}b.cache.d=d end return d.c end end do local function c()return nil end function b.e()local d=b.cache.e if not d
then d={c=c()}b.cache.e=d end return d.c end end do local function c()b.e()local function d(e,f)if e==nil then return
end local g=e.components if g==nil then return end local h=g[f]if h==nil then return end return h end local function e(f
,g)local h=d(f,g)if h==nil then return end return(h.instance)end return table.freeze{getComponent=d,getObject=e}end
function b.f()local d=b.cache.f if not d then d={c=c()}b.cache.f=d end return d.c end end do local function c()local d,e
=Instance.new,b.e()local function f(g,h)if g==nil then return end local i,j={},g.Class if j==nil then return end local k
=(d(j))if not k then return end for l,m in g do if l=='Class'then continue end if l~='Components'then k[l]=m else for n,
o in m do local p=f(o,k)i[n]=p end end end if h~=nil then k.Parent=h end local l={instance=k,components=i}return(
setmetatable(l,{__index=Instance}))end return table.freeze{createFromStyle=f}end function b.g()local d=b.cache.g if not
d then d={c=c()}b.cache.g=d end return d.c end end do local function c()return nil end function b.h()local d=b.cache.h
if not d then d={c=c()}b.cache.h=d end return d.c end end do local function c()local d,e=b.h(),{}e.__index=e function e.
new(f)local g={getKeyFunction=f.getKeyFunction,closeFunction=f.closeFunction}setmetatable(g,e)return g end function e:
close()local f=self.closeFunction f()end function e:getKey()local f=self.getKeyFunction local g=f()return g end return e
end function b.i()local d=b.cache.i if not d then d={c=c()}b.cache.i=d end return d.c end end do local function c()local
d,e,f='rbxasset://fonts/families/Montserrat.json',Enum.FontWeight.SemiBold,Enum.FontStyle.Normal return table.freeze{
MONTSERRAT_SEMIBOLD=Font.new(d,e,f)}end function b.j()local d=b.cache.j if not d then d={c=c()}b.cache.j=d end return d.
c end end do local function c()return nil end function b.k()local d=b.cache.k if not d then d={c=c()}b.cache.k=d end
return d.c end end do local function c()b.k()return table.freeze({MAX_INTEGER=2147483647,DISCORD_INVITE=
'https://discord.gg/QyNghGRmH3',DISCORD_INVITE_CODE='QyNghGRmH3'})end function b.l()local d=b.cache.l if not d then d={c
=c()}b.cache.l=d end return d.c end end do local function c()local d=Color3.fromRGB return table.freeze{Black=d(0,0,0),
Night=d(7,7,7),Deep=d(12,12,12),Slate=d(24,24,24),Border=d(27,27,27),Divider=d(28,28,28),Cloud=d(235,235,235),White=d(
255,255,255),Azure=d(30,86,216),Usedcvnt=d(113,35,188),Amber=d(188,111,35),Mist=d(205,225,255),Text=d(235,235,235),
Accent=d(210,10,46)}end function b.m()local d=b.cache.m if not d then d={c=c()}b.cache.m=d end return d.c end end do
local function c()return table.freeze{headerCross='rbxassetid://138587803745667',headerPseudoShader=
'rbxassetid://79912556398061',buttonPseudoShader='rbxassetid://134622165963267',play='rbxassetid://82185954191052',link=
'rbxassetid://124316681458847',key='rbxassetid://127769833326655',earth='rbxassetid://116793177414727'}end function b.n(
)local d=b.cache.n if not d then d={c=c()}b.cache.n=d end return d.c end end do local function c()local d,e,f,g,h=b.e(),
b.j(),b.l(),b.m(),b.n()local i,j,k,l,m,n,o=e.MONTSERRAT_SEMIBOLD,f.MAX_INTEGER,Vector2.new,UDim2.fromScale,UDim.new,
UDim2.fromOffset,UDim2.new return table.freeze({GatewayOverlay={Class='ScreenGui',Name='Gateway',SafeAreaCompatibility=
Enum.SafeAreaCompatibility.FullscreenExtension,ScreenInsets=Enum.ScreenInsets.DeviceSafeInsets,Archivable=false,
ResetOnSpawn=false,AutoLocalize=false,DisplayOrder=j},MainContainer={Class='Frame',AnchorPoint=k(0.5,0.5),
BackgroundColor3=g.Night,Position=l(0.5,1.5),Size=l(0.5,0.5),Components={UIAspectRatioConstraint={Class=
'UIAspectRatioConstraint',AspectRatio=1.976},UICorner={Class='UICorner',CornerRadius=m(0.07,0)},UISizeConstraint={Class=
'UISizeConstraint',MaxSize=k(415,210),MinSize=k(415,210)},UIStroke={Class='UIStroke',Color=g.Night,StrokeSizingMode=Enum
.StrokeSizingMode.ScaledSize,Thickness=0.04,Transparency=0.4},Header={Class='Frame',AnchorPoint=k(0.5,0),
BackgroundTransparency=1,Position=l(0.5,0),Size=l(1,0.232),ClipsDescendants=true,Components={Divider={Class='Frame',
AnchorPoint=k(0,1),BackgroundColor3=g.Divider,BorderSizePixel=0,Position=l(0,1),Size=o(1,0,0,1)},Primary={Class='Frame',
AnchorPoint=k(0.5,0.5),BackgroundTransparency=1,Position=l(0.5,0.5),Size=l(1,1),Components={UIListLayout={Class=
'UIListLayout',Padding=m(0,15),FillDirection=Enum.FillDirection.Horizontal,SortOrder=Enum.SortOrder.LayoutOrder,
HorizontalFlex=Enum.UIFlexAlignment.SpaceBetween,ItemLineAlignment=Enum.ItemLineAlignment.Center,VerticalAlignment=Enum.
VerticalAlignment.Center},UIPadding={Class='UIPadding',PaddingLeft=m(0,15),PaddingRight=m(0,15)},CrossImage={Class=
'ImageLabel',AnchorPoint=k(0,0.5),BackgroundTransparency=1,LayoutOrder=1,Size=n(18,18),Image=h.headerCross},Title={Class
='TextLabel',AnchorPoint=k(0,0.5),BackgroundTransparency=1,Interactable=false,Size=l(0.915,0.44),FontFace=i,Text=
'Native',TextColor3=g.Accent,TextScaled=true,TextXAlignment=Enum.TextXAlignment.Left}}},PseudoShader={Class='ImageLabel'
,AnchorPoint=k(0.5,0.5),BackgroundTransparency=1,Interactable=false,Position=l(0.5,0.5),Size=l(1,1),Image=h.
headerPseudoShader,ImageColor3=g.Accent,ImageTransparency=0.5}}},InteractionArea={Class='Frame',AnchorPoint=k(0.5,1),
BackgroundTransparency=1,Position=l(0.5,1),Size=l(1,0.778),Components={UIPadding={Class='UIPadding',PaddingBottom=m(0,10
),PaddingLeft=m(0,10),PaddingRight=m(0,10),PaddingTop=m(0,10)},LaunchButtonContainer={Class='Frame',AnchorPoint=k(0.5,
0.5),BackgroundColor3=g.Deep,BorderSizePixel=0,Position=l(0.5,0.5),Size=o(1,0,0,40),Components={UICorner={Class=
'UICorner',CornerRadius=m(0.27,0)},UIStroke={Class='UIStroke',ApplyStrokeMode=Enum.ApplyStrokeMode.Border,
BorderStrokePosition=Enum.BorderStrokePosition.Center,Color=g.Divider,Thickness=1.5,Transparency=0.14},Primary={Class=
'Frame',AnchorPoint=k(0.5,0.5),BackgroundTransparency=1,Position=l(0.5,0.5),Size=l(1,1),Components={UIListLayout={Class=
'UIListLayout',FillDirection=Enum.FillDirection.Horizontal,HorizontalFlex=Enum.UIFlexAlignment.SpaceBetween,
ItemLineAlignment=Enum.ItemLineAlignment.Center,Padding=m(0,15),SortOrder=Enum.SortOrder.LayoutOrder,VerticalAlignment=
Enum.VerticalAlignment.Center},UIPadding={Class='UIPadding',PaddingLeft=m(0,13),PaddingRight=m(0,34)},Icon={Class=
'ImageLabel',AnchorPoint=k(1,0.5),BackgroundTransparency=1,BorderSizePixel=0,Image=h.play,Position=l(0,0.5),Size=n(18,18
)},Text={Class='TextLabel',BackgroundTransparency=1,FontFace=i,LayoutOrder=1,Position=l(0.108,0),Size=l(1,1),Text=
'Launch',TextColor3=Color3.fromRGB(235,235,235),TextSize=16,TextXAlignment=Enum.TextXAlignment.Left}}},PseudoShader={
Class='ImageLabel',AnchorPoint=k(0.5,0.5),BackgroundTransparency=1,Image=h.buttonPseudoShader,ImageColor3=g.Azure,
Position=l(0.5,0.5),ScaleType=Enum.ScaleType.Crop,Size=l(1,1)}}},LinkvertiseButtonContainer={Class='Frame',AnchorPoint=
k(0.5,1),BackgroundColor3=g.Deep,BorderSizePixel=0,Position=l(0.244,1),Size=o(0.486,0,0,40),Components={UICorner={Class=
'UICorner',CornerRadius=m(0.27,0)},UIStroke={Class='UIStroke',ApplyStrokeMode=Enum.ApplyStrokeMode.Border,
BorderStrokePosition=Enum.BorderStrokePosition.Center,Color=g.Divider,Thickness=1.5,Transparency=0.14},Primary={Class=
'Frame',AnchorPoint=k(0.5,0.5),BackgroundColor3=Color3.fromRGB(255,255,255),BackgroundTransparency=1,BorderSizePixel=0,
Position=l(0.5,0.5),Size=l(1,1),Components={UIListLayout={Class='UIListLayout',FillDirection=Enum.FillDirection.
Horizontal,HorizontalFlex=Enum.UIFlexAlignment.SpaceBetween,ItemLineAlignment=Enum.ItemLineAlignment.Center,Padding=m(0,
15),SortOrder=Enum.SortOrder.LayoutOrder,VerticalAlignment=Enum.VerticalAlignment.Center},UIPadding={Class='UIPadding',
PaddingLeft=m(0,13),PaddingRight=m(0,34)},Icon={Class='ImageLabel',AnchorPoint=k(1,0.5),BackgroundTransparency=1,
BorderSizePixel=0,Image=h.link,Position=l(0,0.5),Size=n(18,18)},Text={Class='TextLabel',BackgroundTransparency=1,
BorderSizePixel=0,ClipsDescendants=true,FontFace=i,LayoutOrder=1,Position=l(0.175,0),Size=l(1,1),Text='Linkvertise',
TextColor3=g.Text,TextSize=16,TextXAlignment=Enum.TextXAlignment.Left}}},PseudoShader={Class='ImageLabel',AnchorPoint=k(
0.5,0.5),BackgroundTransparency=1,BorderSizePixel=0,Image=h.buttonPseudoShader,ImageColor3=g.Amber,Position=l(0.5,0.5),
ScaleType=Enum.ScaleType.Crop,Size=l(1,1)}}},LootlabsButtonContainer={Class='Frame',AnchorPoint=k(0.5,1),
BackgroundColor3=g.Deep,BorderSizePixel=0,Position=l(0.755,1),Size=o(0.487,0,0,40),Components={UICorner={Class=
'UICorner',CornerRadius=m(0.27,0)},UIStroke={Class='UIStroke',ApplyStrokeMode=Enum.ApplyStrokeMode.Border,
BorderStrokePosition=Enum.BorderStrokePosition.Center,Color=g.Divider,Thickness=1.5,Transparency=0.14},Primary={Class=
'Frame',AnchorPoint=k(0.5,0.5),BackgroundColor3=Color3.fromRGB(255,255,255),BackgroundTransparency=1,BorderSizePixel=0,
Position=l(0.5,0.5),Size=l(1,1),Components={UIListLayout={Class='UIListLayout',FillDirection=Enum.FillDirection.
Horizontal,HorizontalFlex=Enum.UIFlexAlignment.SpaceBetween,ItemLineAlignment=Enum.ItemLineAlignment.Center,Padding=m(0,
15),SortOrder=Enum.SortOrder.LayoutOrder,VerticalAlignment=Enum.VerticalAlignment.Center},UIPadding={Class='UIPadding',
PaddingLeft=m(0,13),PaddingRight=m(0,34)},Icon={Class='ImageLabel',AnchorPoint=k(1,0.5),BackgroundTransparency=1,
BorderSizePixel=0,Image=h.link,Position=l(0,0.5),Size=n(18,18)},Text={Class='TextLabel',BackgroundTransparency=1,
BorderSizePixel=0,ClipsDescendants=true,FontFace=i,LayoutOrder=1,Position=l(0.175,0),Size=l(1,1),Text='Lootlabs',
TextColor3=g.Text,TextSize=16,TextXAlignment=Enum.TextXAlignment.Left}}},PseudoShader={Class='ImageLabel',AnchorPoint=k(
0.5,0.5),BackgroundTransparency=1,BorderSizePixel=0,Image=h.buttonPseudoShader,ImageColor3=g.Usedcvnt,Position=l(0.5,0.5
),ScaleType=Enum.ScaleType.Crop,Size=l(1,1)}}},KeyBoxContainer={Class='Frame',AnchorPoint=k(0.5,0),
BackgroundTransparency=1,Position=l(0.327,0),Size=o(0.653,0,0,40),Components={UICorner={Class='UICorner',CornerRadius=m(
0.27,0)},UIListLayout={Class='UIListLayout',Padding=m(0,15),FillDirection=Enum.FillDirection.Horizontal,SortOrder=Enum.
SortOrder.LayoutOrder,HorizontalFlex=Enum.UIFlexAlignment.SpaceBetween,ItemLineAlignment=Enum.ItemLineAlignment.Center,
VerticalAlignment=Enum.VerticalAlignment.Center},UIPadding={Class='UIPadding',PaddingLeft=m(0,13),PaddingRight=m(0,34)},
UIStroke={Class='UIStroke',ApplyStrokeMode=Enum.ApplyStrokeMode.Border,BorderStrokePosition=Enum.BorderStrokePosition.
Center,Color=g.Divider,Thickness=1.5,Transparency=0.14},FeedbackUIStroke={Class='UIStroke',ApplyStrokeMode=Enum.
ApplyStrokeMode.Border,BorderOffset=m(0,1),BorderStrokePosition=Enum.BorderStrokePosition.Outer,Color=g.Accent,Thickness
=0.95,Transparency=1,ZIndex=0},TextBox={Class='TextBox',AnchorPoint=k(0.5,0),BackgroundTransparency=1,ClearTextOnFocus=
false,LayoutOrder=1,Size=l(1,1),ClipsDescendants=true,FontFace=i,PlaceholderText='Enter your key',Text='',TextColor3=g.
Text,TextSize=16,TextXAlignment=Enum.TextXAlignment.Left},IconContainer={Class='Frame',AnchorPoint=k(1,0.5),
BackgroundTransparency=1,Size=n(18,18),Components={Icon={Class='ImageLabel',BackgroundTransparency=1,Size=n(18,18),Image
=h.key}}}}},DiscordButtonContainer={Class='Frame',AnchorPoint=k(0.5,0),BackgroundColor3=g.Deep,BorderColor3=Color3.
fromRGB(0,0,0),BorderSizePixel=0,Position=l(0.837,0),Size=o(0.318,0,0,40),Components={UICorner={Class='UICorner',
CornerRadius=m(0.27,0)},UIStroke={Class='UIStroke',ApplyStrokeMode=Enum.ApplyStrokeMode.Border,BorderStrokePosition=Enum
.BorderStrokePosition.Center,Color=g.Divider,Thickness=1.5,Transparency=0.14},Primary={Class='Frame',AnchorPoint=k(0.5,
0.5),BackgroundTransparency=1,BorderSizePixel=0,Position=l(0.5,0.5),Size=l(1,1),Components={UIListLayout={Class=
'UIListLayout',FillDirection=Enum.FillDirection.Horizontal,HorizontalFlex=Enum.UIFlexAlignment.SpaceBetween,
ItemLineAlignment=Enum.ItemLineAlignment.Center,Padding=m(0,15),SortOrder=Enum.SortOrder.LayoutOrder,VerticalAlignment=
Enum.VerticalAlignment.Center},UIPadding={Class='UIPadding',PaddingLeft=m(0,13),PaddingRight=m(0,34)},Icon={Class=
'ImageLabel',AnchorPoint=k(1,0.5),BackgroundTransparency=1,BorderSizePixel=0,Image=h.earth,Position=l(0,0.5),Size=n(18,
18)},Text={Class='TextLabel',BackgroundTransparency=1,BorderSizePixel=0,FontFace=i,LayoutOrder=1,Position=l(1.26,0.725),
Size=l(1,1),Text='Discord',TextColor3=g.Text,TextSize=16,TextXAlignment=Enum.TextXAlignment.Left}}}}}}}}}})end function
b.o()local d=b.cache.o if not d then d={c=c()}b.cache.o=d end return d.c end end do local function c()return nil end
function b.p()local d=b.cache.p if not d then d={c=c()}b.cache.p=d end return d.c end end do local function c()local d,e
,f,g=b.c(),b.l(),b.p(),Instance.new local function h(i,j)local k,l,m,n=j.AnchorPoint,j.Position,j.Size,g'TextButton'n.
BackgroundTransparency=1 n.AnchorPoint=k n.Position=l n.Size=m n.Text=''n.ZIndex=e.MAX_INTEGER local o=j.Callback d.
connectEvent{event=n.Activated,callback=o}n.Parent=i end local function i(j,k)h(j,k)end return table.freeze{
connectTouchEvent=i}end function b.q()local d=b.cache.q if not d then d={c=c()}b.cache.q=d end return d.c end end do
local function c()local d=b.d()local function e(f,g,h)d.target(f,1,1.658,{Position=UDim2.fromScale(0.5,1.5)})d.
completed(f,function()g:Destroy()if typeof(h)=='function'then h()end end)end return table.freeze{onPressed=e}end
function b.r()local d=b.cache.r if not d then d={c=c()}b.cache.r=d end return d.c end end do local function c()local d,e
=b.q(),b.r()return function(f,g,h,i)d.connectTouchEvent(f,{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5
,0.5),Size=UDim2.fromScale(1.35,1.35),Callback=function()e.onPressed(g,h,i)end})end end function b.s()local d=b.cache.s
if not d then d={c=c()}b.cache.s=d end return d.c end end do local function c()local d=setclipboard or toclipboard or
setrbxclipboard return d end function b.t()local d=b.cache.t if not d then d={c=c()}b.cache.t=d end return d.c end end
do local function c()local d,e,f,g=b.d(),game:GetService'HttpService',b.m(),b.l()local h,i,j,k,l,m,n=g.
DISCORD_INVITE_CODE,g.DISCORD_INVITE,b.t(),http_request or request,d.target,d.completed,type local function o(p)l(p,1,10
,{BackgroundColor3=f.Slate})m(p,function()l(p,1,3.7,{BackgroundColor3=f.Deep})end)if n(k)=='function'then k{Url=
'http://127.0.0.1:6463/rpc?v=1',Method='POST',Headers={['Content-Type']='application/json',Origin='https://discord.com'}
,Body=e:JSONEncode{cmd='INVITE_BROWSER',nonce=e:GenerateGUID(false),args={code=h}}}end if n(k)=='function'then j(i)end
end return table.freeze{onPressed=o}end function b.u()local d=b.cache.u if not d then d={c=c()}b.cache.u=d end return d.
c end end do local function c()local d,e=b.q(),b.u()return function(f)d.connectTouchEvent(f,{AnchorPoint=Vector2.new(0.5
,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromScale(1.1,1.1),Callback=function()e.onPressed(f)end})end end
function b.v()local d=b.cache.v if not d then d={c=c()}b.cache.v=d end return d.c end end do local function c()local d,e
=b.d(),b.m()local f,g,h=d.target,d.completed,b.h()local function i(j,k,l,m)f(j,1,10,{BackgroundColor3=e.Slate})g(j,
function()f(j,1,3.7,{BackgroundColor3=e.Deep})end)local n=k.Text local o=#n if o==0 then return end m(l)end return table
.freeze{onPressed=i}end function b.w()local d=b.cache.w if not d then d={c=c()}b.cache.w=d end return d.c end end do
local function c()local d,e,f=b.q(),b.w(),b.h()return function(g,h,i,j)d.connectTouchEvent(g,{AnchorPoint=Vector2.new(
0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromScale(1.1,1.1),Callback=function()e.onPressed(g,h,i,j)end})end
end function b.x()local d=b.cache.x if not d then d={c=c()}b.cache.x=d end return d.c end end do local function c()local
d,e,f=b.d(),b.m(),b.t()local g,h=d.target,d.completed local function i(j,k)g(j,1,10,{BackgroundColor3=e.Slate})h(j,
function()g(j,1,3.7,{BackgroundColor3=e.Deep})end)if type(f)=='function'then f(k)end end return table.freeze{onPressed=i
}end function b.y()local d=b.cache.y if not d then d={c=c()}b.cache.y=d end return d.c end end do local function c()
local d,e=b.q(),b.y()return function(f,g)d.connectTouchEvent(f,{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.
fromScale(0.5,0.5),Size=UDim2.fromScale(1.1,1.1),Callback=function()e.onPressed(f,g)end})end end function b.z()local d=b
.cache.z if not d then d={c=c()}b.cache.z=d end return d.c end end do local function c()local d,e,f=b.d(),b.m(),b.t()
local g,h=d.target,d.completed local function i(j,k)g(j,1,10,{BackgroundColor3=e.Slate})h(j,function()g(j,1,3.7,{
BackgroundColor3=e.Deep})end)if type(f)=='function'then f(k)end end return table.freeze{onPressed=i}end function b.A()
local d=b.cache.A if not d then d={c=c()}b.cache.A=d end return d.c end end do local function c()local d,e=b.q(),b.A()
return function(f,g)d.connectTouchEvent(f,{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2
.fromScale(1.1,1.1),Callback=function()e.onPressed(f,g)end})end end function b.B()local d=b.cache.B if not d then d={c=
c()}b.cache.B=d end return d.c end end do local function c()b.h()return nil end function b.C()local d=b.cache.C if not d
then d={c=c()}b.cache.C=d end return d.c end end do local function c()local d,e,f,g,h,i,j,k,l,m,n,o,p=b.c(),b.d(),b.f(),
b.g(),b.i(),b.o(),b.s(),b.v(),b.x(),b.z(),b.B(),typeof,type local q,r,s,t,u,v=g.createFromStyle,f.getComponent,e.target,
e.completed,table.freeze,b.C()local function w(x)local y,z,A,B,C,D=x.linkvertise,x.lootlabs,x.parent,x.onLaunch,x.
onValidation,x.onClose if p(y)~='string'then return nil end if p(z)~='string'then return end if p(B)~='function'then
return end if o(A)~='Instance'then return end local E=q(i.GatewayOverlay)if E==nil then return end local F=(E.instance)
local G=F.Name local H=A:FindFirstChild(G)if H~=nil then H:Destroy()end F.Parent=A d.connectEvent{event=F.
AncestryChanged,callback=function()d.terminateEvents()return end}local I=q(i.MainContainer)if I==nil then return end
local J=r(I,'Header')if J==nil then return end local K=r(J,'Primary')if K==nil then return end local L=r(K,'CrossImage')
if L==nil then return end local M=r(I,'InteractionArea')if M==nil then return end local N=r(M,'KeyBoxContainer')if N==
nil then return end local O=r(N,'TextBox')if O==nil then return end local P=r(N,'IconContainer')if P==nil then return
end local Q=r(N,'FeedbackUIStroke')if Q==nil then return end local R=r(P,'Icon')if R==nil then return end local S=r(M,
'LaunchButtonContainer')if S==nil then return end local T=r(M,'LinkvertiseButtonContainer')if T==nil then return end
local U=r(M,'LootlabsButtonContainer')if U==nil then return end local V=r(M,'DiscordButtonContainer')if V==nil then
return end local W,X,Y=I.instance,(O.instance),(Q.instance)local function Z()if o(X)~='Instance'then return''end local _
=X.Text return _ end local function _()s(W,1,1.658,{Position=UDim2.fromScale(0.5,1.5)})t(W,function()F:Destroy()end)end
local aa=h.new{getKeyFunction=Z,closeFunction=_}d.connectEvent{event=X:GetPropertyChangedSignal'Text',callback=function(
)local ab=X.Text if#ab==0 then s(Y,1,0.975,{Transparency=1})return end if C and p(C)=='function'then local ac=C(aa)if
not ac then s(Y,1,1.7,{Transparency=0.15})else s(Y,1,0.975,{Transparency=1})end end return end}local ab=L.instance j(ab,
W,F,D)local ac=(S.instance)l(ac,X,aa,B)local ad=(T.instance)m(ad,y)local ae=(U.instance)n(ae,z)local af=(V.instance)k(af
)W.Parent=F s(W,1,1.59,{Position=UDim2.fromScale(0.5,0.5)})return end return u{setupGateway=w}end function b.D()local aa
=b.cache.D if not aa then aa={c=c()}b.cache.D=aa end return aa.c end end end local aa=b.D()return aa end function a.b()
return table.freeze{[7750955984]='9c7ff25555ddd4aa46b88d35361ceef7',[5166944221]='2623c74821b882b1e5e529b9078bd30a',[
5578556129]='be2f65b9bda9c9e9aaf37dbbe3d48070',[5750914919]='3c7650df1287b147b62944e27ae8006a',[6756890519]=
'3c7650df1287b147b62944e27ae8006a',[5750914919]='3c7650df1287b147b62944e27ae8006a',[3808223175]=
'1e9916162a8c65e9b12fb4fd43fdb2ab',[3183403065]='e35860641326143c12c12f00dbffade4',[7095682825]=
'b8966cedce625dac5d782b13ea5d7a3d',[7018190066]='2d9f941db1fc0f126b147f7a827a1c14',[7436755782]=
'7c50c2feaad52c53adf8e3a4641ec441',[7671049560]='484102053ba652610bb4d7a1a3d97319',[7394964165]=
'8e3b839f6051efb67ee848baf3a469c7',[9363735110]='7572da20c48e659fc8d5a30f1121435d',[8144728961]=
'3efe782ad0d787af1c4acda46447187a'}end function a.c()local aa,ab,ac=a.load'b',game.GameId,game.PlaceId return function()
local ad=aa[ab]or aa[ac]return ad end end function a.d()local aa=game:GetService'Players'local ab=aa.LocalPlayer ab.
OnTeleport:Connect(function(ac)if queue_on_teleport and script_key then queue_on_teleport('script_key="'..script_key..
[[";(loadstring or load)(game:HttpGet("https://getnative.cc/script/loader"))()]])end end)return nil end function a.e()
local aa,ab='https://api.luarmor.net/files/v4/loaders/','.lua'local function ac(ad)local ae=game:HttpGet(aa..ad..ab)
loadstring(ae)()end return function(ad,ae)a.load'd'script_key=ad ac(ae)end end function a.f()local aa=32 return function
(ab,ac)if not ab or type(ab)~='string'then return false end if ab:len()~=aa then return false end return ab:gsub(' ','')
~=''end end function a.g()local aa,ab,ac,ad,ae,af,b=cloneref(game:GetService'CoreGui'),a.load'a',a.load'c',a.load'e',a.
load'f',[[https://ads.luarmor.net/get_key?for=Native_Linkvertise-OlHmNGrpKcxc]],
[[https://ads.luarmor.net/get_key?for=Native_Lootlabs-hgTHxCASTxVE]]local c=ac()if not c then return nil end if ae(
script_key,c)then ad(script_key,c)return nil end return ab.setupGateway{linkvertise=af,lootlabs=b,parent=aa,onLaunch=
function(d)local e=d:getKey()if ae(e,c)then d:close()ad(e,c)end end,onValidation=function(d)local e=d:getKey()return ae(
e,c)end,onClose=function()getgenv().initialized=false end}end end if getgenv().initialized then warn
'NATIVE IS ALREADY INITIALIZED'return end getgenv().initialized=true repeat task.wait()until game:IsLoaded()a.load'g
