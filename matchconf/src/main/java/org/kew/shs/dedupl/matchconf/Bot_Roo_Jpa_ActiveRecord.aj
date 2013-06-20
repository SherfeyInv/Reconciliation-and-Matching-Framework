// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package org.kew.shs.dedupl.matchconf;

import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import org.kew.shs.dedupl.matchconf.Bot;
import org.springframework.transaction.annotation.Transactional;

privileged aspect Bot_Roo_Jpa_ActiveRecord {
    
    @PersistenceContext
    transient EntityManager Bot.entityManager;
    
    public static final EntityManager Bot.entityManager() {
        EntityManager em = new Bot() {
            public java.util.List<? extends org.kew.shs.dedupl.matchconf.Bot> getComposedBy() {
                throw new UnsupportedOperationException();
            }
        }.entityManager;
        if (em == null) throw new IllegalStateException("Entity manager has not been injected (is the Spring Aspects JAR configured as an AJC/AJDT aspects library?)");
        return em;
    }
    
    public static long Bot.countBots() {
        return entityManager().createQuery("SELECT COUNT(o) FROM Bot o", Long.class).getSingleResult();
    }
    
    public static List<Bot> Bot.findAllBots() {
        return entityManager().createQuery("SELECT o FROM Bot o", Bot.class).getResultList();
    }
    
    public static Bot Bot.findBot(Long id) {
        if (id == null) return null;
        return entityManager().find(Bot.class, id);
    }
    
    public static List<Bot> Bot.findBotEntries(int firstResult, int maxResults) {
        return entityManager().createQuery("SELECT o FROM Bot o", Bot.class).setFirstResult(firstResult).setMaxResults(maxResults).getResultList();
    }
    
    @Transactional
    public void Bot.persist() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.persist(this);
    }
    
    @Transactional
    public void Bot.remove() {
        if (this.entityManager == null) this.entityManager = entityManager();
        if (this.entityManager.contains(this)) {
            this.entityManager.remove(this);
        } else {
            Bot attached = Bot.findBot(this.id);
            this.entityManager.remove(attached);
        }
    }
    
    @Transactional
    public void Bot.flush() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.flush();
    }
    
    @Transactional
    public void Bot.clear() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.clear();
    }
    
    @Transactional
    public Bot Bot.merge() {
        if (this.entityManager == null) this.entityManager = entityManager();
        Bot merged = this.entityManager.merge(this);
        this.entityManager.flush();
        return merged;
    }
    
}
