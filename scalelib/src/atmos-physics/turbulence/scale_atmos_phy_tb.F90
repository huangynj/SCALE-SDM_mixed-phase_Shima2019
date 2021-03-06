!-------------------------------------------------------------------------------
!> module ATMOSPHERE / Physics Turbulence
!!
!! @par Description
!!          Sub-grid scale turbulence process
!!
!! @author Team SCALE
!!
!! @par History
!! @li      2013-12-05 (S.Nishizawa) [new]
!! @li      2014-03-30 (A.Noda)      [mod] add DNS
!!
!<
!-------------------------------------------------------------------------------
module scale_atmos_phy_tb
  !-----------------------------------------------------------------------------
  !
  !++ used modules
  !
  use scale_precision
  use scale_stdio
  use scale_prof
  use scale_grid_index
  use scale_tracer
  !-----------------------------------------------------------------------------
  implicit none
  private
  !-----------------------------------------------------------------------------
  !
  !++ Public procedure
  !
  public :: ATMOS_PHY_TB_setup

  !-----------------------------------------------------------------------------
  !
  !++ Public parameters & variables
  !
  !-----------------------------------------------------------------------------
  !
  !++ Private procedure
  !
  !-----------------------------------------------------------------------------
  !
  !++ Private parameters & variables
  !
  abstract interface
     subroutine tb( &
       qflx_sgs_momz, qflx_sgs_momx, qflx_sgs_momy, & ! (out)
       qflx_sgs_rhot, qflx_sgs_rhoq,                & ! (out)
       tke,                                         & ! (inout)
       tke_t, nu_C, Ri, Pr, N2,                     & ! (out) diagnostic variables
       MOMZ, MOMX, MOMY, RHOT, DENS, QTRC,          & ! (in)
       SFLX_MW, SFLX_MU, SFLX_MV, SFLX_SH, SFLX_QV, & ! (in)
       GSQRT, J13G, J23G, J33G, MAPF, dt            ) ! (in)
       use scale_precision
       use scale_grid_index
       use scale_tracer
       implicit none
       real(RP), intent(out) :: qflx_sgs_momz(KA,IA,JA,3)
       real(RP), intent(out) :: qflx_sgs_momx(KA,IA,JA,3)
       real(RP), intent(out) :: qflx_sgs_momy(KA,IA,JA,3)
       real(RP), intent(out) :: qflx_sgs_rhot(KA,IA,JA,3)
       real(RP), intent(out) :: qflx_sgs_rhoq(KA,IA,JA,3,QA)

       real(RP), intent(inout) :: TKE(KA,IA,JA)
       real(RP), intent(out)   :: tke_t(KA,IA,JA) ! tendency TKE
       real(RP), intent(out)   :: nu_C(KA,IA,JA) ! eddy viscosity (center)
       real(RP), intent(out)   :: Ri  (KA,IA,JA) ! Richardson number
       real(RP), intent(out)   :: Pr  (KA,IA,JA) ! Prantle number
       real(RP), intent(out)   :: N2  (KA,IA,JA) ! squared Brunt-Vaisala frequency

       real(RP), intent(in)  :: MOMZ(KA,IA,JA)
       real(RP), intent(in)  :: MOMX(KA,IA,JA)
       real(RP), intent(in)  :: MOMY(KA,IA,JA)
       real(RP), intent(in)  :: RHOT(KA,IA,JA)
       real(RP), intent(in)  :: DENS(KA,IA,JA)
       real(RP), intent(in)  :: QTRC(KA,IA,JA,QA)

       real(RP), intent(in)  :: SFLX_MW(IA,JA)
       real(RP), intent(in)  :: SFLX_MU(IA,JA)
       real(RP), intent(in)  :: SFLX_MV(IA,JA)
       real(RP), intent(in)  :: SFLX_SH(IA,JA)
       real(RP), intent(in)  :: SFLX_QV(IA,JA)

       real(RP), intent(in)  :: GSQRT   (KA,IA,JA,7) !< vertical metrics {G}^1/2
       real(RP), intent(in)  :: J13G    (KA,IA,JA,7) !< (1,3) element of Jacobian matrix
       real(RP), intent(in)  :: J23G    (KA,IA,JA,7) !< (1,3) element of Jacobian matrix
       real(RP), intent(in)  :: J33G                 !< (3,3) element of Jacobian matrix
       real(RP), intent(in)  :: MAPF    (IA,JA,2,4)  !< map factor
       real(DP), intent(in)  :: dt
     end subroutine tb
  end interface
  procedure(tb), pointer :: ATMOS_PHY_TB => NULL()
  public :: ATMOS_PHY_TB

  !-----------------------------------------------------------------------------
contains

  subroutine ATMOS_PHY_TB_setup( &
       TB_TYPE,       &
       CDZ, CDX, CDY, &
       CZ             )
    use scale_process, only: &
       PRC_MPIstop
#define EXTM(pre, name, post) pre ## name ## post
#define NAME(pre, name, post) EXTM(pre, name, post)
#ifdef TB
    use NAME(scale_atmos_phy_tb_, TB,), only: &
       NAME(ATMOS_PHY_TB_, TB, _setup), &
       NAME(ATMOS_PHY_TB_, TB,)
#else
    use scale_atmos_phy_tb_smg, only: &
       ATMOS_PHY_TB_smg_setup, &
       ATMOS_PHY_TB_smg
    use scale_atmos_phy_tb_dns, only: &
       ATMOS_PHY_TB_dns_setup, &
       ATMOS_PHY_TB_dns
    use scale_atmos_phy_tb_mynn, only: &
       ATMOS_PHY_TB_mynn_setup, &
       ATMOS_PHY_TB_mynn
    use scale_atmos_phy_tb_hybrid, only: &
       ATMOS_PHY_TB_hybrid_setup, &
       ATMOS_PHY_TB_hybrid
    use scale_atmos_phy_tb_dummy, only: &
       ATMOS_PHY_TB_dummy_setup, &
       ATMOS_PHY_TB_dummy
#endif
    implicit none

    character(len=*), intent(in) :: TB_TYPE

    real(RP), intent(in) :: CDZ(KA)
    real(RP), intent(in) :: CDX(IA)
    real(RP), intent(in) :: CDY(JA)
    real(RP), intent(in) :: CZ (KA,IA,JA)
    !---------------------------------------------------------------------------

#ifdef TB
    call NAME(ATMOS_PHY_TB_, TB, _setup)( &
              TB_TYPE,       &
              CDZ, CDX, CDY, &
              CZ             )
    ATMOS_PHY_TB                 => NAME(ATMOS_PHY_TB_, TB, )
#else
    select case( TB_TYPE )
    case ( 'SMAGORINSKY' )
       call ATMOS_PHY_tb_smg_setup( &
            TB_TYPE,       &
            CDZ, CDX, CDY, &
            CZ             )
       ATMOS_PHY_TB => ATMOS_PHY_TB_smg

    case ( 'DNS' )
       call ATMOS_PHY_tb_dns_setup( &
            TB_TYPE,       &
            CDZ, CDX, CDY, &
            CZ             )
       ATMOS_PHY_TB => ATMOS_PHY_TB_dns

    case ( 'MYNN' )
       call ATMOS_PHY_tb_mynn_setup( &
            TB_TYPE,       &
            CDZ, CDX, CDY, &
            CZ             )
       ATMOS_PHY_TB => ATMOS_PHY_TB_mynn

    case ('HYBRID')
       call ATMOS_PHY_tb_hybrid_setup( &
            TB_TYPE,       &
            CDZ, CDX, CDY, &
            CZ             )
       ATMOS_PHY_TB => ATMOS_PHY_TB_hybrid

    case ('OFF')

       ! do nothing

    case default

       write(*,*) 'xxx ATMOS_PHY_TB_TYPE is invalid'
       call PRC_MPIstop

    end select
#endif

    return
  end subroutine ATMOS_PHY_TB_setup

end module scale_atmos_phy_tb
