package org.fao.geonet.domain;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.annotation.Nonnull;
import javax.persistence.Access;
import javax.persistence.AccessType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.Lob;
import javax.persistence.ManyToMany;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import com.vividsolutions.jts.util.Assert;

/**
 * An entity representing a metadata object in the database. The xml, groups and operations are lazily loaded so accessing then will need to
 * be done in a thread that has a bound EntityManager. Also they can trigger database access if they have not been cached and therefore can
 * cause slowdowns so they should only be accessed in need.
 * 
 * @author Jesse
 */
@Entity
@Table(name = "metadata")
@Access(AccessType.PROPERTY)
public class Metadata {

    private int _id;
    private String _uuid;
    private String _data;
    private MetadataDataInfo _dataInfo;
    private MetadataSourceInfo _sourceInfo;
    private MetadataHarvestInfo _harvestInfo;
    private List<OperationAllowed> _operationsAllowed = new ArrayList<OperationAllowed>();
    private Set<MetadataCategory> _metadataCategories = new HashSet<MetadataCategory>();
//    private List<MetadataStatus> _metadataStatus;
    // private Set<Operation> operations = new HashSet<Operation>();
    // private Set<Group> groups = new HashSet<Group>();

    @Id
    @GeneratedValue
    @Column(nullable = false)
    public int getId() {
        return _id;
    }

    public Metadata setId(int _id) {
        this._id = _id;
        return this;
    }

    @Column(nullable = false)
    @Nonnull
    public String getUuid() {
        return _uuid;
    }

    @Nonnull
    public Metadata setUuid(@Nonnull String uuid) {
        Assert.isTrue(uuid != null, "Cannot have null uuid");
        this._uuid = uuid;
        return this;
    }

    @Column(nullable=false)
    @Lob
    public String getData() {
        return _data;
    }

    public void setData(String data) {
        this._data = data;
    }

    @Embedded
    public MetadataDataInfo getDataInfo() {
        return _dataInfo;
    }

    public void setDataInfo(MetadataDataInfo dataInfo) {
        this._dataInfo = dataInfo;
    }

    @Embedded
    public MetadataSourceInfo getSourceInfo() {
        return _sourceInfo;
    }

    public void setSourceInfo(MetadataSourceInfo sourceInfo) {
        this._sourceInfo = sourceInfo;
    }

    @Embedded
    public MetadataHarvestInfo getHarvestInfo() {
        return _harvestInfo;
    }

    public void setHarvestInfo(MetadataHarvestInfo harvestInfo) {
        this._harvestInfo = harvestInfo;
    }

    // /**
    // * Get the read-only set of operations that are assocated with
    // * this metadata. This is essentially a view onto operations allowed
    // * and isn't automatically updated when operationsAllowed is updated
    // */
    // @ManyToMany(fetch = FetchType.LAZY)
    // @JoinTable(name = "operationallowed", joinColumns = @JoinColumn(name = "operationid"), inverseJoinColumns = @JoinColumn(name =
    // "metadataid"))
    // @Nonnull
    // public Set<Operation> getOperations() {
    // return Collections.unmodifiableSet(operations);
    // }
    //
    // /**
    // * Get the read-only collection of groups that are assocated with
    // * this metadata. This is essentially a view onto operations allowed
    // * and isn't automatically updated when operationsAllowed is updated
    // */
    // @ManyToMany(fetch = FetchType.LAZY)
    // @JoinTable(name = "operationallowed", joinColumns = @JoinColumn(name = "groupid"), inverseJoinColumns = @JoinColumn(name =
    // "metadataid"))
    // @Nonnull
    // public Set<Group> getGroups() {
    // return Collections.unmodifiableSet(groups);
    // }
    // /**
    // * Get the read-only collection of groups that are assocated with
    // * this metadata. This is essentially a view onto operations allowed
    // * and isn't automatically updated when operationsAllowed is updated
    // */
    // @ManyToMany(fetch = FetchType.LAZY)
    // @JoinTable(name = "operationallowed", joinColumns = @JoinColumn(name = "groupid"), inverseJoinColumns = @JoinColumn(name =
    // "metadataid"))
    // @Nonnull
    // public Set<Group> getGroups() {
    // return Collections.unmodifiableSet(groups);
    // }

     /**
     * Get the read-only collection of groups that are assocated with
     * this metadata. This is essentially a view onto operations allowed
     * and isn't automatically updated when operationsAllowed is updated
     */
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "metadatacateg", joinColumns = @JoinColumn(name = "categoryid"), inverseJoinColumns = @JoinColumn(name = "metadataid"))
    @Nonnull
    public Set<MetadataCategory> getCategories() {
        return _metadataCategories;
    }

    public void setCategories(Set<MetadataCategory> categories) {
        this._metadataCategories = categories;
    }
    public Metadata addOperationAllowed(OperationAllowed newOperationAllowed) {
        internalAddOperationAllowed(newOperationAllowed);
        newOperationAllowed.internalSetMetadata(this);
        return this;
    }

    public Metadata removeOperationAllowed(OperationAllowed oldOperationAllowed) {
        internalRemoveOperationAllowed(oldOperationAllowed);
        oldOperationAllowed.internalSetMetadata(null);
        return this;
    }

    void internalAddOperationAllowed(OperationAllowed newOperationAllowed) {
        Assert.isTrue(newOperationAllowed != null, OperationAllowed.class.getSimpleName() + " should not be null");
        if (!_operationsAllowed.contains(newOperationAllowed)) {
            this._operationsAllowed.add(newOperationAllowed);
        }
    }

    /**
     * Get a <strong>unmodifiable</strong> collection containing the operations allowed
     */
    @OneToMany(fetch = FetchType.LAZY)
    @JoinColumn(name = "metadataid")
    public List<OperationAllowed> getOperationsAllowed() {
        return this._operationsAllowed;
    }

    /**
     * Set operationallowed collection. Should only be used when creating the object.
     * 
     * @param operationAllowed the operation allowed collection
     */
    protected void setOperationsAllowed(List<OperationAllowed> operationAllowed) {
        this._operationsAllowed = operationAllowed;
    }

    void internalRemoveOperationAllowed(OperationAllowed operationAllowed) {
        this._operationsAllowed.remove(operationAllowed);
    }
}