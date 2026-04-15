package group05.ccmtptpm.ams.controller;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.RequestParam;



@Controller
public class WebController {

    @GetMapping("")
    public String defaultLogin() {
        System.out.println("Accessing login page");
        return "login";
    }

    @GetMapping("/login")
    public String loginPage() {
        System.out.println("Accessing login page");
        return "login";
    }

    @GetMapping("/register")
    public String registerPage() {
        return "register";
    }

    @GetMapping("/user/dashboard")
    @PreAuthorize("hasAnyRole('USER', 'ADMIN')")
    public String userDashboard() {
        return "user/assets";
    }

    // Trang cho admin
    @GetMapping("/admin/dashboard")
    @PreAuthorize("hasRole('ADMIN')")
    public String adminDashboard() {
        return "admin/admin_dashboard";
    }   
    @GetMapping("/admin/types")
    @PreAuthorize("hasRole('ADMIN')")
    public String adminAssetTypes() {
        return "admin/asset_types";
    }

    @GetMapping("/admin/requests")
    @PreAuthorize("hasRole('ADMIN')")
    public String adminRequest() {
        return "admin/requests";
    }
    @GetMapping("/admin/assets")
    @PreAuthorize("hasRole('ADMIN')")
    public String adminAssets() {
        return "admin/assets";
    }
    // Trang cho user
    // @GetMapping("/user/dashboard")
    // public String userDashboard() {
    //     return "user_dashboard";
    // }
    @GetMapping("/user/assets")
    @PreAuthorize("hasAnyRole('USER', 'ADMIN')")
    public String userAssets() {
        return "user/assets";
    }
    @GetMapping("/user/request")
    @PreAuthorize("hasAnyRole('USER', 'ADMIN')")
    public String userRequest() {
    return "user/request"; 
}
}
