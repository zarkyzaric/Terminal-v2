#Requires AutoHotkey v2.0
#SingleInstance Force


; ščžćđŠČŽĆĐ
;---------------------
:*?:\vs::š
:*?:\vc::č
:*?:\vz::ž
:*?:\'c::ć
:*?:\;c::ć
:*?:\dj::đ
:*?:\vS::Š
:*?:\vC::Č
:*?:\vZ::Ž
:*?:\'C::Ć
:*?:\;C::Ć
:*?:\Dj::Đ



; Often fast writing mistakes
;---------------------
::its::it's
::I am::I'm
::Im::I'm
::I will::I'll
::Ill::I'll
::does not::doesn't
::did not::didn't
::ws::was
::hwo::how
::wich::which
::ot::to
::oyu::you
::yuo::you
::aer::are
::eigth::eight
::comander::commander
::coudl::could
::teh::the
::thier::their
::recieve::receive
::adress::address
::alot::a lot
::becuase::because
::definately::definitely
::tomorow::tomorrow
::yesteray::yesterday
::untill::until
::occured::occurred
::oppurtunity::opportunity
::recomend::recommend
::seperate::separate
::wierd::weird
::buisness::business
::goverment::government
::neccessary::necessary
::ocassion::occasion
::publically::publicly
::rythm::rhythm
::saftey::safety
::suprise::surprise
::tommorow::tomorrow
::tounge::tongue
::truely::truly
::usally::usually
::usefull::useful
::whould::would
::writting::writing


; Hard or Long words
;---------------------
:*:params::parameters
:*:Params::Parameters


;Often mistakes
;---------------------
::beldner::blender  
::roatioin::rotation
::rotaitn::rotation
::roatitn::rotation
::rotiatin::rotation
::rotaiitin::rotation
::rotaitn::rotation
::roataiotn::rotation
::roation::rotation
::rotatin::rotation
::rptation::rotation
::rotiatin::rotation
::rortation::rotation
::animaiton::animation
::downlaod::download
::compilaiton::compilation


; Clipboard Modifiers
;---------------------
:*:clipupper::{
    A_Clipboard := StrUpper(A_Clipboard)
}
; :*:cliplower::{
;     A_Clipboard := StrLower(A_Clipboard)
; }
; :*:cliptitle::{
;     A_Clipboard := StrTitle(A_Clipboard)
; }

















