// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package org.kew.stringmod.matchconf;

import java.util.List;
import org.kew.stringmod.matchconf.Transformer;
import org.springframework.transaction.annotation.Transactional;

privileged aspect Transformer_Roo_Jpa_ActiveRecord {
    
    public static long Transformer.countTransformers() {
        return entityManager().createQuery("SELECT COUNT(o) FROM Transformer o", Long.class).getSingleResult();
    }
    
    public static List<Transformer> Transformer.findAllTransformers() {
        return entityManager().createQuery("SELECT o FROM Transformer o", Transformer.class).getResultList();
    }
    
    public static Transformer Transformer.findTransformer(Long id) {
        if (id == null) return null;
        return entityManager().find(Transformer.class, id);
    }
    
    public static List<Transformer> Transformer.findTransformerEntries(int firstResult, int maxResults) {
        return entityManager().createQuery("SELECT o FROM Transformer o", Transformer.class).setFirstResult(firstResult).setMaxResults(maxResults).getResultList();
    }
    
    @Transactional
    public Transformer Transformer.merge() {
        if (this.entityManager == null) this.entityManager = entityManager();
        Transformer merged = this.entityManager.merge(this);
        this.entityManager.flush();
        return merged;
    }
    
}