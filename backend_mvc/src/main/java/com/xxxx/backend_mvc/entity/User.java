package com.xxxx.backend_mvc.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.xxxx.backend_mvc.entity.workspace.WorkspaceMember;
import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;
import java.util.Set;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity
@Table(name = "users") // đổi để tránh conflict với SQL keyword "user"
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "user_id")
    String id;

    @Column(name = "user_name", length = 50, nullable = false)
    String username;

    @Column(name = "user_email", length = 255, nullable = false, unique = true)
    String email;

    @Column(name = "user_password", nullable = false)
    String password;

    @Column(name = "user_firstname", length = 255)
    String firstName;

    @Column(name = "user_lastname", length = 255)
    String lastName;

    LocalDate dob;

    @ManyToMany(fetch = FetchType.EAGER)
    Set<Role> roles;

    @JsonIgnore
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    Set<WorkspaceMember> workspaceMembers;
}
