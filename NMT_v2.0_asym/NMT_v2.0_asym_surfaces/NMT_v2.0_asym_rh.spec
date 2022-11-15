# delimits comments

# define the group
        Group = NMT_v2.0_asym

# define various States
        StateDef = white_surface
        StateDef = mid_surface
        StateDef = gray_surface
        StateDef = white_surface.inf_300.rsl
        StateDef = mid_surface.inf_300.rsl
        StateDef = gray_surface.inf_300.rsl

NewSurface
        SurfaceFormat = ASCII
        SurfaceType = GIFTI
        SurfaceName = rh.white_surface.rsl.gii
        LocalDomainParent = rh.white_surface.rsl.gii
        SurfaceState = white_surface
        EmbedDimension = 3
        Anatomical = Y

NewSurface
        SurfaceFormat = ASCII
        SurfaceType = GIFTI
        SurfaceName = rh.mid_surface.rsl.gii
        LocalDomainParent = rh.mid_surface.rsl.gii
        SurfaceState = mid_surface
        EmbedDimension = 3
        Anatomical = Y

NewSurface
        SurfaceFormat = ASCII
        SurfaceType = GIFTI
        SurfaceName = rh.gray_surface.rsl.gii
        LocalDomainParent = rh.gray_surface.rsl.gii
        SurfaceState = gray_surface
        EmbedDimension = 3
        Anatomical = Y

NewSurface
        SurfaceFormat = ASCII
        SurfaceType = GIFTI
        SurfaceName = rh.white_surface.inf_300.rsl.gii
        LocalDomainParent = rh.white_surface.rsl.gii
        SurfaceState = white_surface.inf_300
        EmbedDimension = 3
        Anatomical = N

NewSurface
        SurfaceFormat = ASCII
        SurfaceType = GIFTI
        SurfaceName = rh.mid_surface.inf_300.rsl.gii
        LocalDomainParent = rh.mid_surface.rsl.gii
        SurfaceState = mid_surface.inf_300
        EmbedDimension = 3
        Anatomical = N

NewSurface
        SurfaceFormat = ASCII
        SurfaceType = GIFTI
        SurfaceName = rh.gray_surface.inf_300.rsl.gii
        LocalDomainParent = rh.gray_surface.rsl.gii
        SurfaceState = gray_surface.inf_300
        EmbedDimension = 3
        Anatomical = N