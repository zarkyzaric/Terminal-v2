#Requires AutoHotkey v2.0
#SingleInstance Force



    ; Often words
; Often fast writing mistakes
;---------------------

:*?B0:{::{}}{Left}

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

;Contractions
;---------------------
; ::its::it's
::I am::I'm
::I will::I'll
::Ill::I'll
::does not::doesn't
::did not::didn't
:*C:He is::He's
:*C:he is::he's
:*C:He will::He'll
:*C:he will::he'll
:*C:He would::He'd
:*C:he would::he'd
:*C:I am::I'm
:*C:i am::I'm
:*C:I had::I'd
:*C:i had::I'd
:*C:I have::I've
:*C:i have::I've
:*C:I will::I'll
:*C:i will::I'll
:*C:It had::It'd
:*C:it had::it'd
:*C:It is::It's
:*C:it is::it's
:*C:It will::It'll
:*C:it will::it'll
:*C:She had::She'd
:*C:she had::she'd
:*C:She is::She's
:*C:she is::she's
:*C:She will::She'll
:*C:she will::she'll
:*C:That had::That'd
:*C:that had::that'd
:*C:That is::That's
:*C:that is::that's
:*C:That will::That'll
:*C:that will::that'll
:*C:We are::We're
:*C:we are::we're
:*C:We had::We'd
:*C:we had::we'd
:*C:We have::We've
:*C:we have::we've
:*C:We will::We'll
:*C:we will::we'll
:*C:What had::What'd
:*C:what had::what'd
:*C:What has::What's
:*C:what has::what's
:*C:What is::What's
:*C:what is::what's
:*C:What will::What'll
:*C:what will::what'll
:*C:Who had::Who'd
:*C:who had::who'd
:*C:Who has::Who's
:*C:who has::who's
:*C:Who is::Who's
:*C:who is::who's
:*C:Who will::Who'll
:*C:who will::who'll
:*C:You are::You're
:*C:you are::you're
:*C:You had::You'd
:*C:you had::you'd
:*C:You have::You've
:*C:you have::you've
:*C:You will::You'll
:*C:you will::you'll
:*C:Shes::She's
:*C:shes::she's
:*C:Thatd::That'd
:*C:thatd::that'd
:*C:Thats::That's
:*C:thats::that's
:*C:Thatll::That'll
:*C:thatll::that'll
:*C:Whats::What's
:*C:whats::what's
:*C:Whatll::What'll
:*C:whatll::what'll
:*C:Whos::Who's
:*C:whos::who's
:*C:Wholl::Who'll
:*C:wholl::who'll
:*C:Youre::You're
:*C:youre::you're
:*C:Youve::You've
:*C:youve::you've
:*C:Youll::You'll
:*C:youll::you'll

; Short words - Autocorrect
::adn::and
::teh::the
::taht::that
::ot::to
::fo::of
::whihc::which
::yo::you
::haev::have
::hvae::have
::doe::does
::owrk::work 
::owkr::work 
::okwr::work 
::okwr::work 
::wokr::work 
::orw::or
::shoud::should
::shoud::should 
::coud::could
::woud::would
::tihs::this
::tkae::take
::tae::take
::jsut::just
::jst::just
::basc::basic
::thsi::this
::ths::this
::reall::really
::really::really
::frmo::from
::form::from
::udner::under
::unti::until
::biuld::build
::bulid::build
::ahve::have
::sotp::stop   
::sopt::stop 
::cuz::because 
::becasue::because
::becuase::because
::aywa::away
::awy::away 
::bale::able
::abel::able
::hlep::help
::nothig::nothing
::nohting::nothing
::severla::several 
::several::several
::abit::a bit
::abit::a bit

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
; :*:cliplower::{
;     A_Clipboard := StrLower(A_Clipboard)
; }
; :*:clipupper::{
;     A_Clipboard := StrUpper(A_Clipboard)
; }
; :*:cliptitle::{
    ;     A_Clipboard := StrTitle(A_Clipboard)
; }

; ščžćđŠČŽĆĐ
;---------------------
:*?:\vs::š
:*?:\sh::š
:*?:\vc::č
:*?:\ch::č
:*?:\vz::ž
:*?:\zh::ž
:*?:\'c::ć
:*?:\;c::ć
:*?:\dj::đ
:*?:\vS::Š
:*?:\Sh::Š
:*?:\vC::Č
:*?:\Ch::Č
:*?:\vZ::Ž
:*?:\Zh::Ž
:*?:\'C::Ć
:*?:\;C::Ć
:*?:\Dj::Đ
