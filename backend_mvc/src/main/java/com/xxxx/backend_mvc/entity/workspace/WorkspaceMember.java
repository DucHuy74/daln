package com.xxxx.backend_mvc.entity.workspace;

import com.xxxx.backend_mvc.entity.User;
import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "workspace_member")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class WorkspaceMember {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "wsm_id")
    String id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    User user;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "wsp_id", nullable = false)
    Workspace workspace;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "wsp_role_id", nullable = false)
    WorkspaceRole workspaceRole;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    LocalDateTime updatedAt;
}
